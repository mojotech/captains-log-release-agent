defmodule ReleaseNotesBotWeb.SlackInteractionController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.{Projects, Channels}
  alias ReleaseNotesBotWeb.SlackInteractionView

  @channel_config_event "channel-configured-with-client"
  @new_project_event "new-project"
  @new_client_event "new-client"
  @manual_release_event "manual-release"

  def index(conn, params) do
    %{"view" => view, "user" => user} = Projects.parse_params(params)

    case Projects.parse_response(view) do
      %{client: client_name, channel: channel} ->
        Channels.post_message(
          channel,
          SlackInteractionView.message(@channel_config_event, user["name"], client_name)
        )

      %{client: client, project: project_name, peristence: url, add_webhook: webhook} ->
        Channels.post_message_all_client_channels(
          client,
          SlackInteractionView.message(
            @new_project_event,
            user["name"],
            client.name,
            project_name,
            url,
            webhook
          )
        )

      %{details: details, client: client} when client.channels != nil ->
        Channels.post_message_all_client_channels(
          client,
          SlackInteractionView.message(
            @manual_release_event,
            user["name"],
            details.project,
            details
          )
        )

      %{client: client_name} ->
        Channels.post_message(
          Application.get_env(:release_notes_bot, :slack_blast_channel),
          SlackInteractionView.message(@new_client_event, user["name"], client_name)
        )

      _ ->
        nil
    end

    Plug.Conn.send_resp(conn, 204, [])
  end
end
