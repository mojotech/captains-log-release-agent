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

      %{client: client, project: project_name, peristence: url, add_webhook: webhook} ->
        Channels.post_message_all_client_channels(
          client,
          "#{user["name"]} has created a new project under #{client.name} titled: '#{project_name}'. Release notes will be persisted to " <>
            where_to_persist(url) <> determine_serve_repo_webhook_url(webhook)
        )

      %{details: details, client: client} when client.channels != nil ->
        Channels.post_message_all_client_channels(
          client,
          "<!here>\n#{user["name"]} has posted a Release Note to '#{details.project}' titled: '#{details.title}'.\nDetails:\n#{details.message}\n\nView on Confluence: #{details.persistence_url}"
        )

      %{client: client_name} ->
        # TO DO: send user a pm with links to docs
        # TO DO: register this channel with the client and send a message there.
        Channels.post_message(
          Application.get_env(:release_notes_bot, :slack_blast_channel),
          "#{user["name"]} has created new client: #{client_name}"
        )

      _ ->
        nil
    end

    Plug.Conn.send_resp(conn, 204, [])
  end

  defp where_to_persist(url) do
    case url do
      nil -> "the default location."
      _ -> "<#{url}|this specified location>."
    end
  end

  defp determine_serve_repo_webhook_url(webhook) do
    case webhook do
      nil -> ""
      _ -> ". Click <#{webhook}|this link> to add a webhook to your repository."
    end
  end
end
