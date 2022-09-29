defmodule ReleaseNotesBotWeb.WebhookController do
  @moduledoc """
  This module is used for consuming webhook events.
  """
  use ReleaseNotesBotWeb, :controller
  alias ReleaseNotesBot.{Projects, WebhookEvents, Repositories, Clients, Channels, Persists}

  @release_actions ["published", "deleted"]
  @persist_actions ["published"]
  @source_adv_repo_url "https://github.com/mojotech/source_advisors"
  @source_adv_confluence 48_070_657

  def post(conn, params) do
    body = Projects.parse_params(params)

    case body["release"] do
      nil ->
        Task.async(fn -> process_event(body) end)

      _ ->
        Task.async(fn -> process_release(body) end)
    end

    conn |> Plug.Conn.send_resp(201, [])
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

  defp process_release(body = %{"repository" => repo, "action" => action})
       when action in @release_actions do
    case repo_match = Repositories.get(observed_id: Integer.to_string(repo["id"])) do
      # Check if incoming repo url/id exists as a repo entry and has a project relation
      %{project_id: project_id} when project_id != nil ->
        WebhookEvents.create_async(body, repo_match.id)

        # TO DO: We can request what the settings are for each event then handle them accordingly
        # TO DO: Simplify repo -> project -> client -> channel relation
        project = Projects.get(id: project_id)

        # Build message and push a slack message to all channels
        Channels.post_message_all_client_channels(
          Clients.get_channels(project.client_id),
          build_message(body)
        )

        determine_persistence(body, repo_match.url)

      _ ->
        nil
    end
  end

  defp process_release(_), do: nil

  defp replace_bullets(body), do: String.replace("\n" <> body, ["\n* ", "\n- "], "\n• ")

  def build_message(%{"release" => release, "repository" => repo, "action" => action}) do
    case action do
      "deleted" ->
        "Update for repository: #{repo["full_name"]}\n\n#{release["author"]["login"]} has #{action} the release on tag: #{release["tag_name"]}"

      "edited" ->
        "Update for repository: #{repo["full_name"]}\n\n#{release["author"]["login"]} has #{action} the release on tag: #{release["tag_name"]}\n\nDetails:\n#{replace_bullets(release["body"])}"

      _ ->
        "Update for repository: #{repo["full_name"]}\n\n#{release["author"]["login"]} has #{action} '#{release["name"]}' on tag: '#{release["tag_name"]}'\n\nDetails:\n#{replace_bullets(release["body"])}"
    end
  end

  defp determine_persistence(%{"release" => release, "action" => action}, match_url) do
    # Persist to persistence provider
    if action in @persist_actions do
      if match_url == @source_adv_repo_url do
        Persists.persist(release["name"], release["body"], @source_adv_confluence)
      else
        Persists.persist(release["name"], release["body"])
      end
    end
  end
end
