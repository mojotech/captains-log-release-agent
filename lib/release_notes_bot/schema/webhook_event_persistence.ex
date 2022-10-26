defmodule ReleaseNotesBot.Schema.WebhookEventPersistence do
  @moduledoc """
  This module is used as a join table between webhook events and persistence providers.
  This table also includes a slug which is used to identify the webhook event in the persistence provider.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "webhook_event_persistences" do
    field(:slug, :string)
    field(:version, :integer)
    belongs_to(:webhook_event, ReleaseNotesBot.Schema.WebhookEvent)
    belongs_to(:persistence_provider, ReleaseNotesBot.Schema.PersistenceProvider)

    timestamps()
  end

  def changeset(webhook_event_persistence, params) do
    webhook_event_persistence
    |> cast(params, [:slug, :version, :webhook_event_id, :persistence_provider_id])
    |> validate_required([:slug, :webhook_event_id, :persistence_provider_id])
  end
end
