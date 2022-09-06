defmodule ReleaseNotesBotWeb.CaptainsController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.{Clients, Projects, Channels}
  alias ReleaseNotesBotWeb.CaptainsView

  def index(conn, params) do
    body = Projects.parse_params(params)

    Task.async(fn ->
      ReleaseNotesBot.Users.register(body["user_name"], body["user_id"])
    end)

    ReleaseNotesBot.Channels.register(body["channel_name"], body["channel_id"])

    case body["text"] do
      "new client" ->
        Slack.Web.Views.open(
          Application.get_env(
            :release_notes_bot,
            :slack_bot_token
          ),
          body["trigger_id"],
          Jason.encode!(CaptainsView.new_client())
        )

      "new project" ->
        {:ok, view} =
          Clients.get_all()
          |> CaptainsView.new_project()
          |> Jason.encode()

        Slack.Web.Views.open(
          Application.get_env(
            :release_notes_bot,
            :slack_bot_token
          ),
          body["trigger_id"],
          view
        )

      "" ->
        check_channel(body)

      _ ->
        nil
    end

    conn |> Plug.Conn.send_resp(204, [])
  end

  defp check_channel(body) do
    %ReleaseNotesBot.Schema.Channel{client_id: client_id} =
      Channels.get_client(slack_id: body["channel_id"])

    case client_id do
      nil ->
        {:ok, view} =
          Clients.get_all()
          |> CaptainsView.gen_client_view(body["channel_name"], body["channel_id"])
          |> Jason.encode()

        Slack.Web.Views.open(
          Application.get_env(
            :release_notes_bot,
            :slack_bot_token
          ),
          body["trigger_id"],
          view
        )

      _ ->
        data = ReleaseNotesBot.Clients.get_projects(client_id)

        {:ok, view} =
          data.projects
          |> CaptainsView.gen_release_notes_view()
          |> Jason.encode()

        Slack.Web.Views.open(
          Application.get_env(
            :release_notes_bot,
            :slack_bot_token
          ),
          body["trigger_id"],
          view
        )
    end
  end
end
