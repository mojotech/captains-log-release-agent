defmodule ReleaseNotesBot.Note do
  @moduledoc """
  This module is used to model Project Notes.
  A Project can have 0 or many Notes.
  Notes must be persisted to a Persistence Provider
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias ReleaseNotesBot.Repo
  alias __MODULE__

  schema "notes" do
    field(:title, :string)
    field(:message, :string)
    belongs_to(:project, ReleaseNotesBot.Project)

    timestamps()
  end

  def changeset(note, params) do
    note
    |> cast(params, [:project_id, :title, :message])
    |> validate_required([:project_id, :title, :message])
  end

  def create(params) do
    %Note{}
    |> changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(Note)
  end

  # Get a note by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(Note, param)
  end
end
