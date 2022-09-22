defmodule ReleaseNotesBot.Schema.ProjectProvider do
  @moduledoc """
  This module is used to model a join table between Project and Persistence Provider.
  A Client Stakeholder can have 0 or many Projects.
  A Project can have 0 or many Notes.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_providers" do
    belongs_to(:persistence_provider, ReleaseNotesBot.Schema.PersistenceProvider)
    belongs_to(:project, ReleaseNotesBot.Schema.Project)
    field :config, :map

    timestamps()
  end

  def changeset(project, params) do
    project
    |> cast(params, [:project_id, :persistence_provider_id, :config])
    |> validate_required([:project_id, :persistence_provider_id])
  end
end
