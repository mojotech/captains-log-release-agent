defmodule ReleaseNotesBot.ReleaseTags do
  @moduledoc """
  Embedded schema for the release tags view which is a query onto of the existing webhook events.
  """

  alias ReleaseNotesBot.Schema.WebhookEvent
  alias ReleaseNotesBot.{Repo, WebhookEvents}
  import Ecto.Query

  @spec is_published(Integer.t(), String.t()) :: boolean()
  def is_published(repo_id, release_tag_id) do
    case check_for_published_events(repo_id) do
      [matching_repo_id] ->
        case matching_repo_id do
          ^release_tag_id ->
            true

          _ ->
            false
        end

      [] ->
        false
    end
  end

  defp check_for_published_events(repo_id) do
    Repo.all(
      from we in WebhookEvent,
        where: we.repository_id == ^repo_id and fragment("raw_payload->>'action' = 'released'"),
        select: fragment("raw_payload->'release'->>'id'")
    )
  end
end
