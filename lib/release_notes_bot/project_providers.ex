defmodule ReleaseNotesBot.ProjectProviders do
  @moduledoc """
  Repo functions for Project Provider
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.ProjectProvider

  def create(params) do
    %ProjectProvider{}
    |> ProjectProvider.changeset(params)
    |> Repo.insert()
  end

  def create_default(project_id) do
    %ProjectProvider{}
    |> ProjectProvider.changeset(%{
      project_id: project_id,
      persistence_provider_id: 1,
      # TO DO: This should be able to be set by the user in the future
      config: %{
        "space_id" => Application.get_env(:release_notes_bot, :confluence_space_id),
        "space_key" => Application.get_env(:release_notes_bot, :confluence_space_key),
        "parent_id" => Application.get_env(:release_notes_bot, :confluence_parent_id),
        "organization" => Application.get_env(:release_notes_bot, :confluence_organization)
      }
    })
    |> Repo.insert()
  end

  def get_all do
    Repo.all(ProjectProvider)
  end

  def get(param) do
    Repo.get_by(ProjectProvider, param)
  end
end
