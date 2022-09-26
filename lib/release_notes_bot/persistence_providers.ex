defmodule ReleaseNotesBot.PersistenceProviders do
  @moduledoc """
  Repo functions for Persistence Provider
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.PersistenceProvider
  alias ReleaseNotesBot.ProjectProviders

  def create(params) do
    %PersistenceProvider{}
    |> PersistenceProvider.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(PersistenceProvider)
  end

  def get(param) do
    Repo.get_by(PersistenceProvider, param)
  end

  def parse_url_and_create(url, project_id) do
    case URI.parse(url) do
      %URI{
        port: 443,
        scheme: "https",
        host: "mojotech.atlassian.net",
        authority: authority,
        path: path
      } ->
        split_path = String.split(path, "/")
        split_host = String.split(authority, ".")
        confluence_persistence = get(name: "Confluence")

        ProjectProviders.create(%{
          project_id: project_id,
          persistence_provider_id: confluence_persistence.id,
          config: %{
            space_id: Application.get_env(:release_notes_bot, :confluence_space_id),
            space_key: Enum.at(split_path, 3),
            parent_id: Enum.at(split_path, 5),
            organization: Enum.at(split_host, 0)
          }
        })

      _ ->
        nil
    end
  end
end
