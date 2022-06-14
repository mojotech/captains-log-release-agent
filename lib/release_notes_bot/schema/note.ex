defmodule ReleaseNotesBot.Schema.Note do
  @moduledoc """
  This module is used to model Project Notes.
  A Project can have 0 or many Notes.
  Notes must be persisted to a Persistence Provider
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field(:title, :string)
    field(:message, :string)
    belongs_to(:project, ReleaseNotesBot.Schema.Project)

    timestamps()
  end

  def changeset(note, params) do
    note
    |> cast(params, [:project_id, :title, :message])
    |> validate_required([:project_id, :title, :message])
  end
end
