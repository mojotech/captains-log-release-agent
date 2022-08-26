defmodule ReleaseNotesBot.Schema.Token do
  @moduledoc """
  This module is used to model Project Tokens
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field(:access_token, :string)
    field(:refresh_token, :string)
    belongs_to(:user, ReleaseNotesBot.Schema.User)
    belongs_to(:persistence_provider, ReleaseNotesBot.Schema.PersistenceProvider)

    timestamps()
  end

  def changeset(token, params) do
    token
    |> cast(params, [:access_token, :refresh_token, :user_id, :persistence_provider_id])
    |> validate_required([:access_token, :refresh_token, :user_id, :persistence_provider_id])
  end
end
