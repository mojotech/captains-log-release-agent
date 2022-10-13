defmodule ReleaseNotesBotWeb.WebhookController do
  @moduledoc """
  This module is used for consuming webhook events.
  """
  use ReleaseNotesBotWeb, :controller

  alias ReleaseNotesBot.{
    Projects,
    WebhookEvents,
    Repositories,
    Clients,
    Channels,
    Persists,
    ReleaseTags
  }

  @view_on_persistence_message "View on Confluence"

  def post(conn, params) do
    body = Projects.parse_params(params)

    case body["release"] do
      nil ->
        Task.async(fn -> process_event(body) end)

      _ ->
        Task.async(fn -> start_process_release(body) end)
    end

    conn |> Plug.Conn.send_resp(201, [])
  end

  defp start_process_release(body) do
    case repo_match = Repositories.get(observed_id: Integer.to_string(body["repository"]["id"])) do
      # Check if incoming repo url/id exists as a repo entry and has a project relation
      %{project_id: project_id} when project_id != nil ->
        WebhookEvents.create_async(body, repo_match.id)
        process_release(body, project_id)

      _ ->
        nil
    end
  end

  defp process_event(body) do
    # Check if a welcome ping event has been received
    case body["hook"]["ping_url"] do
      nil ->
        nil

      _ ->
        # Check if repo exists.
        {:ok, repo} = Repositories.find_or_create_by_webhook(body["repository"])
        # Persist the event to local postgres instance
        WebhookEvents.create_async(body, repo.id)

        Channels.post_blast_message(
          "New webhook ping event received for #{repo.full_name}.. Created new repository record."
        )
    end
  end

  defp process_release(body = %{"action" => "published"}, project_id) do
    # TO DO: We can request what the settings are for each event then handle them accordingly
    # TO DO: Simplify repo -> project -> client -> channel relation
    project = Projects.get_provider(id: project_id)
    persistence_location = determine_persistence(body, project.project_provider)

    # Build message and push a slack message to all channels
    Channels.post_message_all_client_channels(
      Clients.get_channels(project.client_id),
      build_message(body, persistence_location)
    )
  end

  # Make sure the release has changes to the body
  defp process_release(
         body = %{
           "action" => "edited",
           "changes" => _changes,
           "release" => release,
           "repository" => repo
         },
         project_id
       ) do
    # Has this release tag been published?
    case ReleaseTags.is_published(repo["id"], release["id"]) do
      true ->
        # TO DO: Edit Event on Confluence
        project = Projects.get_provider(id: project_id)
        persistence_location = determine_persistence(body, project.project_provider)

        # TO DO: Post to Slack that event has been edited
        # If we want to diff strings, we can use the myers diff algorithm
        # Channels.post_message_all_client_channels(
        #   Clients.get_channels(project.client_id),
        #   build_message(body, persistence_location)
        # )
        nil

      false ->
        nil
    end
  end

  defp process_release(
         body = %{"action" => "created"},
         project_id
       ) do
    project = Projects.get_provider(id: project_id)

    Channels.post_message_all_client_channels(
      Clients.get_channels(project.client_id),
      build_message(body, nil)
    )
  end

  defp process_release(_body, _project_id), do: nil

  defp replace_bullets(body), do: String.replace("\n" <> body, ["\n* ", "\n- "], "\n• ")

  def build_message(
        %{"release" => release, "repository" => repo, "action" => action},
        persistence
      ) do
    case action do
      "deleted" ->
        "Update for repository: #{repo["full_name"]}\n\n#{release["author"]["login"]} has #{action} the release on tag: #{release["tag_name"]}"

      "edited" ->
        "Update for repository: #{repo["full_name"]}\n\n#{release["author"]["login"]} has #{action} the release on tag: #{release["tag_name"]}\n\nDetails:\n#{replace_bullets(release["body"])}"

      "published" when is_binary(persistence) ->
        "Update for repository: #{repo["full_name"]}\n\n#{release["author"]["login"]} has #{action} '#{release["name"]}' on tag: '#{release["tag_name"]}'\n\nDetails:\n#{replace_bullets(release["body"])}\n\n#{build_slack_url_embed(persistence, @view_on_persistence_message)}"

      "created" when is_nil(persistence) ->
        "#{release["author"]["login"]} has #{action} a draft release on tag: '#{release["tag_name"]}'. #{build_slack_url_embed(release["html_url"], "Click here")} to view on Github."

      _ ->
        "Update for repository: #{repo["full_name"]}\n\n#{release["author"]["login"]} has #{action} '#{release["name"]}' on tag: '#{release["tag_name"]}'\n\nDetails:\n#{replace_bullets(release["body"])}"
    end
  end

  defp determine_persistence(%{"release" => release, "action" => action}, project_provider) do
    # TO DO: Persist to all persistence providers
    case Persists.persist(
           build_persistence_title(release),
           release["body"],
           Enum.take(project_provider, 1) |> List.first(),
           action
         ) do
      {:ok, endpoint} when is_binary(endpoint) ->
        endpoint

      _ ->
        nil
    end
  end

  defp build_persistence_title(release), do: release["tag_name"]

  defp build_slack_url_embed(url, text), do: "<#{url}|#{text}>"
end
