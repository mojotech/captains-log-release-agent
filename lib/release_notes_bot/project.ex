defmodule ReleaseNotesBot.Project do
  @moduledoc """
  This module is used to model a Client Project.
  A Client Stakeholder can have 0 or many Projects.
  A Project can have 0 or many Notes.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias ReleaseNotesBot.Repo
  alias __MODULE__

  schema "projects" do
    field(:name, :string)
    belongs_to(:client, ReleaseNotesBot.Client)
    has_many(:notes, ReleaseNotesBot.Note)

    timestamps()
  end

  def changeset(project, params) do
    project
    |> cast(params, [:client_id, :name])
    |> validate_required([:client_id, :name])
  end

  def create(params) do
    %Project{}
    |> changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(Project)
  end

  # Get a project by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(Project, param)
  end
end
