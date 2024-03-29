defmodule ReleaseNotesBot.ReleaseTags do
  @moduledoc """
  Embedded schema for the release tags view which is a query onto of the existing webhook events.
  """

  alias ReleaseNotesBot.Schema.WebhookEvent
  alias ReleaseNotesBot.{Repo, WebhookEvents}
  import Ecto.Query

  @spec is_published(Integer.t(), String.t()) :: boolean()
  def is_published(repo_id, release_tag_id) do
    repo_id
    |> get_published_events()
    |> Enum.member?(release_tag_id)
  end

  @spec get_id(Integer.t(), String.t()) :: Interger.t()
  def get_id(repo_id, release_tag_id) do
    result =
      repo_id
      |> get_ids_of_published_events()
      |> Enum.find(fn {_id, tag_id} -> tag_id == release_tag_id end)

    case result do
      nil -> nil
      {id, _tag_id} -> id
    end
  end

  defp get_ids_of_published_events(repo_id) do
    repo_id
    |> compose_published_events_query()
    |> select_ids()
    |> Repo.all()
  end

  defp get_published_events(repo_id) do
    repo_id
    |> compose_published_events_query()
    |> select_release_id()
    |> Repo.all()
  end

  defp compose_published_events_query(repo_id) do
    from we in WebhookEvent,
      where: we.repository_id == ^repo_id and fragment("raw_payload->>'action' = 'published'")
  end

  defp select_release_id(query) do
    from q in query, select: fragment("raw_payload->'release'->>'id'")
  end

  defp select_ids(query) do
    from q in query, select: {q.id, fragment("raw_payload->'release'->>'id'")}
  end
end
