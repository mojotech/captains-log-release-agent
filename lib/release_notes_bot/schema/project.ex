defmodule ReleaseNotesBot.Schema.Project do
  @moduledoc """
  This module is used to model a Client Project.
  A Client Stakeholder can have 0 or many Projects.
  A Project can have 0 or many Notes.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field(:name, :string)
    belongs_to(:client, ReleaseNotesBot.Schema.Client)
    has_many(:notes, ReleaseNotesBot.Schema.Note)
    has_many(:project_provider, ReleaseNotesBot.Schema.ProjectProvider)

    timestamps()
  end

  def changeset(project, params) do
    project
    |> cast(params, [:client_id, :name])
    |> validate_required([:client_id, :name])
  end
end
