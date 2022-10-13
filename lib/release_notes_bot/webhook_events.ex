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
end
