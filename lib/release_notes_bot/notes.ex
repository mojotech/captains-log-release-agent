defmodule ReleaseNotesBot.Note do
  @moduledoc """
  Repo functions for Notes
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
