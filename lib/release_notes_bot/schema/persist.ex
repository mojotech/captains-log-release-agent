defmodule ReleaseNotesBot.Schema.Persist do
  @moduledoc """
  This module is used to model what is required
  to persist to a persistence provider.
  """
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:title, :string)
    field(:message, :string)
    field(:space_id, :string)
    field(:space_key, :string)
    field(:parent_id, :string)
    field(:organization, :string)
    field(:endpoint_url, :string)
    field(:endpoint_persistence, :string)
    field(:endpoint_source, :string)
    field(:token, :string)
  end

  def changeset(persist, params) do
    persist
    |> cast(params, [
      :title,
      :message,
      :space_id,
      :space_key,
      :parent_id,
      :token,
      :endpoint_url,
      :endpoint_persistence,
      :endpoint_source,
      :organization
    ])
    |> validate_required([
      :title,
      :message,
      :space_id,
      :space_key,
      :parent_id,
      :token,
      :endpoint_url,
      :endpoint_persistence,
      :endpoint_source,
      :organization
    ])
  end
end
