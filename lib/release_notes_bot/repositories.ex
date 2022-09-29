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

  def update(repo, params) do
    repo
    |> Repository.changeset(params)
    |> Repo.update()
  end

  def find_or_create_by_webhook(raw_repository) do
    # If no repo exists, create a new repo.
    case repo = Repositories.get(url: raw_repository["html_url"]) do
      nil ->
        Repositories.create(%{
          url: raw_repository["html_url"],
          full_name: raw_repository["full_name"],
          observed_id: Integer.to_string(raw_repository["id"])
        })

      _ ->
        Repositories.update(
          repo,
          %{
            url: raw_repository["html_url"],
            full_name: raw_repository["full_name"],
            observed_id: Integer.to_string(raw_repository["id"])
          }
        )
    end
  end

  def find_or_create_by_slack(project_id, repo_url) do
    # Check if repo exists given its url
    case repo = Repositories.get(url: repo_url) do
      # Check if repo exists given its url
      nil ->
        Repositories.create(%{
          url: repo_url,
          project_id: project_id
        })

        repo_url <> "/settings/hooks/new"

      # Check if repo exists given its url
      _ ->
        Repositories.update(repo, %{
          project_id: project_id
        })

        nil
    end
  end
end
