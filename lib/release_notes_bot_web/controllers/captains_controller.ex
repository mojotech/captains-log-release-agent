defmodule ReleaseNotesBotWeb.CaptainsController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.{Clients, Projects}
  alias ReleaseNotesBotWeb.CaptainsView

  @mainchannel "C03B51092F3"
  @channel "D03GYAZ42LE"

  @spec ping(Plug.Conn.t(), any) :: Plug.Conn.t()
  def ping(conn, _params) do
    render(conn, "ping.json")
  end

  def index(conn, params) do
    body = Projects.parse_params(params)

    case Projects.parse_action(body) do
      "open_modal" ->
        Task.async(fn -> serve(body) end)

      "view_submission" ->
        Task.async(fn -> serve(body) end)
    end

    conn |> Plug.Conn.send_resp(200, [])
  end

  defp serve(body = %{"trigger_id" => trigger, "view" => view, "user" => user}) do
    case Projects.parse_response(view) do
      # This case matches the first modal submission once parsed
      %ReleaseNotesBot.Schema.Client{} = data ->
        {:ok, view} =
          data.projects
          |> CaptainsView.gen_release_notes_view()
          |> Jason.encode()

        Slack.Web.Views.open(
          Application.get_env(
            :release_notes_bot,
            :slack_bot_token
          ),
          trigger,
          view
        )

      %{client: client_name, project: project_name} ->
        Slack.Web.Chat.post_message(
          @channel,
          "#{user["name"]} has created a new project for #{client_name} titled: '#{project_name}'"
        )

      %{client: client_name} ->
        Slack.Web.Chat.post_message(
          @channel,
          "#{user["name"]} has created new client: #{client_name}"
        )

      # This case is where the final modal submission hits once parsed.
      %{} = details ->
        Slack.Web.Chat.post_message(
          @channel,
          "<!here>\n#{user["name"]} has posted a Release Note to '#{details.project}' titled: '#{details.note_title}'.\nDetails:\n#{details.note_message}"
        )

      nil ->
        nil

      _ ->
        nil
    end
  end

  defp serve(body) do
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
  end
end
