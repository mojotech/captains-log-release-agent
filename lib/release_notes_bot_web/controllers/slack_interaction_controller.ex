defmodule ReleaseNotesBotWeb.SlackInteractionController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.Projects
  alias ReleaseNotesBotWeb.CaptainsView

  def index(conn, params) do
    %{"view" => view, "user" => user} = Projects.parse_params(params)

    case Projects.parse_response(view) do
      %{client: client_name, channel: channel} ->
        Slack.Web.Chat.post_message(
          channel,
          "#{user["name"]} has configured this channel to accept messages and updates for projects under: #{client_name}"
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
