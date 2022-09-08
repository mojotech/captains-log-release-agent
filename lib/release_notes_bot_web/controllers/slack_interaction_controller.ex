defmodule ReleaseNotesBotWeb.SlackInteractionController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.{Projects, Channels}

  def index(conn, params) do
    %{"view" => view, "user" => user} = Projects.parse_params(params)

    case Projects.parse_response(view) do
      %{client: client_name, channel: channel} ->
        Channels.post_message(
          channel,
          "#{user["name"]} has configured this channel to accept messages and updates for projects under: #{client_name}"
        )

      %{client: client_name, project: project_name} ->
        Channels.post_message(
          Application.get_env(:release_notes_bot, :slack_channel),
          "#{user["name"]} has created a new project for #{client_name} titled: '#{project_name}'"
        )

      %{details: details, client: client} when client.channels != nil ->
        Channels.post_message_all_client_channels(
          client,
          "<!here>\n#{user["name"]} has posted a Release Note to '#{details.project}' titled: '#{details.title}'.\nDetails:\n#{details.message}\n\nPersistence Status: #{details.persistence_status}"
        )

      %{client: client_name} ->
        Channels.post_message(
          Application.get_env(:release_notes_bot, :slack_channel),
          "#{user["name"]} has created new client: #{client_name}"
        )

      _ ->
        nil
    end

    Plug.Conn.send_resp(conn, 204, [])
  end
end
