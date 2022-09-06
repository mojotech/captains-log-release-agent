defmodule ReleaseNotesBot.Schema.PersistenceProvider do
  @moduledoc """
  This module is used to model Project Tokens
  """
  use Ecto.Schema

  schema "persistence_providers" do
    field(:name, :string)
    has_many(:token, ReleaseNotesBot.Schema.Token)

    timestamps()
  end
end