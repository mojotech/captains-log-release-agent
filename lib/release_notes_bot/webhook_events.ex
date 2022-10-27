defmodule ReleaseNotesBot.WebhookEvents do
  @moduledoc """
  Repo functions for Webhook Events
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.WebhookEvent

  def create(params) do
    %WebhookEvent{}
    |> WebhookEvent.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(WebhookEvent)
  end

  def get(param) do
    Repo.get_by(WebhookEvent, param)
  end

  def create_async(payload, repo_id) do
    Task.async(fn ->
      create(%{:raw_payload => payload, :repository_id => repo_id})
    end)
  end

  def update(webhook_event, params) do
    webhook_event
    |> WebhookEvent.changeset(params)
    |> Repo.update()
  end

  def unpublish(webhook_event = %{:raw_payload => %{"action" => "published"}}) do
    update(webhook_event, %{
      :raw_payload => put_in(webhook_event.raw_payload, ["action"], "unpublished")
    })
  end

  def unpublish(_webhook_event), do: nil
end
