defmodule ReleaseNotesBotWeb.CaptainsController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.{Client, Project}
  alias ReleaseNotesBotWeb.CaptainsView

  # Temporary until channels data model is added
  @channel "C03B51092F3"

  def ping(conn, _params) do
    render(conn, "ping.json")
  end

  def index(conn, params) do
    body = Project.parse_params(params)

    case Project.parse_action(body) do
      # Logic for opening a new modal for a user
      "open_modal" ->
        conn |> Plug.Conn.send_resp(200, [])

        {:ok, view} =
          Client.get_all()
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

      # Logic for handing a modal submission
      # We have 2 different view_submissions due to 2 modals
      "view_submission" ->
        conn |> Plug.Conn.send_resp(200, [])

        case Project.parse_response(body) do
          # This case matches the first modal submission once parsed
          %ReleaseNotesBot.Client{} = data ->
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

          # This case is where the final modal submission hits once parsed.
          %{} = details ->
            Slack.Web.Chat.post_message(
              @channel,
              "<!here>\n#{body["user"]["name"]} has posted a Release Note to '#{details.project}' titled: '#{details.note_title}'.\nDetails:\n#{details.note_message}"
            )

          nil ->
            nil

          _ ->
            nil
        end
    end

    conn |> Plug.Conn.halt()
  end
end
