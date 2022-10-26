defmodule ReleaseNotesBot.WebhookEventPersistences do
  @moduledoc """
  Repo functions for Webhook Event Persistences
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.WebhookEventPersistence

  def create(params) do
    %WebhookEventPersistence{}
    |> WebhookEventPersistence.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(WebhookEventPersistence)
  end

  def get(param) do
    Repo.get_by(WebhookEventPersistence, param)
  end

  def create_async(params) do
    Task.async(fn -> create(params) end)
  end

  def update(webhook_event_persistence, params) do
    webhook_event_persistence
    |> WebhookEventPersistence.changeset(params)
    |> Repo.update()
  end
end
