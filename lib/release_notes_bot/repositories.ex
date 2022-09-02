defmodule ReleaseNotesBot.Repositories do
  @moduledoc """
  Repo functions for Repoitories
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Repository
  alias __MODULE__

  def create(params) do
    %Repository{}
    |> Repository.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(Repository)
  end

  def get(param) do
    Repo.get_by(Repository, param)
  end

  def find_or_create(raw_repository) do
    # If no repo exists, create a new repo.
    case repo = Repositories.get(url: raw_repository["html_url"]) do
      nil ->
        Repositories.create(%{
          url: raw_repository["html_url"],
          full_name: raw_repository["full_name"],
          observed_id: Integer.to_string(raw_repository["id"])
        })

      _ ->
        {:ok, repo}
    end
  end
end
