defmodule ReleaseNotesBot.PersistenceProviders do
  @moduledoc """
  Repo functions for Persistence Provider
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.PersistenceProvider

  def create(params) do
    %PersistenceProvider{}
    |> PersistenceProvider.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(PersistenceProvider)
  end

  def get(param) do
    Repo.get_by(PersistencetProvider, param)
  end
end
