defmodule ReleaseNotesBot.Schema.WebhookEvent do
  @moduledoc """
  This module is used to model webhook events.
  A Repository can have 0 or many webhook events.
  webhook events must be persisted to a Persistence Provider.
  Think of webhook events as the automated version of notes.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "webhook_events" do
    field(:raw_payload, :map)
    belongs_to(:repository, ReleaseNotesBot.Schema.Repository)
    has_many(:webhook_event_persistences, ReleaseNotesBot.Schema.WebhookEventPersistence)

    timestamps()
  end

  def changeset(webhook_event, params) do
    webhook_event
    |> cast(params, [:repository_id, :raw_payload])
    |> validate_required([:repository_id, :raw_payload])
  end
end
