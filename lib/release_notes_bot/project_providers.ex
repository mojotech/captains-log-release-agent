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

  def get_all do
    Repo.all(ProjectProvider)
  end

  def get(param) do
    Repo.get_by(ProjectProvider, param)
  end
end
