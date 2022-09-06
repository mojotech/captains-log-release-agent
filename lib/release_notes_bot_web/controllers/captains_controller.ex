defmodule ReleaseNotesBotWeb.CaptainsController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.{Clients, Projects}
  alias ReleaseNotesBotWeb.CaptainsView

  def index(conn, params) do
    body = Projects.parse_params(params)

    Task.async(fn ->
      ReleaseNotesBot.Users.register(body["user_name"], body["user_id"])
    end)

    Task.async(fn ->
      ReleaseNotesBot.Channels.register(body["channel_name"], body["channel_id"])
    end)

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
        {:ok, view} =
          Clients.get_all()
          |> CaptainsView.gen_client_view()
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
        nil
    end

    Plug.Conn.send_resp(conn, 204, [])
  end
end
