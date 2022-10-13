defmodule ReleaseNotesBot.Schema.Repository do
  @moduledoc """
  This module is used to model Project Repositories.
  A Project can have 0 or many Repositories.
  Repositories have 0 or many webhook events.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field(:name, :string)
    field(:full_name, :string)
    field(:is_active, :boolean, default: true)
    field(:observed_id, :string)
    field(:url, :string)

    belongs_to(:project, ReleaseNotesBot.Schema.Project)
    has_many(:webhook_events, ReleaseNotesBot.Schema.WebhookEvent)

    timestamps()
  end

  def changeset(repository, params) do
    repository
    |> cast(params, [:project_id, :name, :full_name, :url, :is_active, :observed_id])
    |> validate_required([:url, :is_active])
  end
end
