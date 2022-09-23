defmodule ReleaseNotesBot.Schema.PersistenceProvider do
  @moduledoc """
  This module is used to model Project Tokens
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "persistence_providers" do
    field(:name, :string)
    has_many(:token, ReleaseNotesBot.Schema.Token)
    has_many(:project_provider, ReleaseNotesBot.Schema.ProjectProvider)

    timestamps()
  end

  def changeset(persistence_provider, params) do
    persistence_provider
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
