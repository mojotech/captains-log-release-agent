defmodule ReleaseNotesBotWeb.SlackInteractionController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.Projects
  alias ReleaseNotesBotWeb.CaptainsView

  def index(conn, params) do
    %{"trigger_id" => trigger, "view" => view, "user" => user} = Projects.parse_params(params)

    case Projects.parse_response(view) do
      data = %ReleaseNotesBot.Schema.Client{} ->
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
          Application.get_env(:release_notes_bot, :slack_channel),
          "#{user["name"]} has created a new project for #{client_name} titled: '#{project_name}'"
        )

      %{client: client_name} ->
        Slack.Web.Chat.post_message(
          Application.get_env(:release_notes_bot, :slack_channel),
          "#{user["name"]} has created new client: #{client_name}"
        )

      # This case is where the final modal submission hits once parsed.
      %{} = details ->
        Slack.Web.Chat.post_message(
          Application.get_env(:release_notes_bot, :slack_channel),
          "<!here>\n#{user["name"]} has posted a Release Note to '#{details.project}' titled: '#{details.title}'.\nDetails:\n#{details.message}\n\nPersistence Status: #{details.persistence_status}"
        )

      _ ->
        nil
    end

    Plug.Conn.send_resp(conn, 204, [])
  end
end
