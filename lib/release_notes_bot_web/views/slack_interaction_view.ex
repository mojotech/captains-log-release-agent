defmodule ReleaseNotesBotWeb.SlackInteractionView do
  use ReleaseNotesBotWeb, :view

  @channel_config_event "channel-configured-with-client"
  @new_project_event "new-project"
  @new_client_event "new-client"
  @manual_release_event "manual-release"

  def message(@manual_release_event, user, project, details) do
    "<!here>\n#{user} has posted a Release Note to '#{project}' titled: '#{details.title}'.\nDetails:\n#{details.message}\n\nView on Confluence: #{details.persistence_url}"
  end

  def message(@new_project_event, user, client, project, url, webhook) do
    "#{user} has created a new project under #{client} titled: '#{project}'. Release notes will be persisted to #{where_to_persist(url) <> determine_serve_repo_webhook_url(webhook)}"
  end

  def message(@new_client_event, user, client) do
    "#{user} has created new client: #{client}"
  end

  def message(@channel_config_event, user, client) do
    "#{user} has configured this channel to accept messages and updates for projects under: #{client}"
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
