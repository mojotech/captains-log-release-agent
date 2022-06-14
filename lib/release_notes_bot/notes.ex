defmodule ReleaseNotesBot.Note do
  @moduledoc """
  This module is used to model Project Notes.
  A Project can have 0 or many Notes.
  Notes must be persisted to a Persistence Provider
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Note

  def create(params) do
    %Note{}
    |> Note.changeset(params)
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
