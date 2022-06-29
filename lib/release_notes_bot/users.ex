defmodule ReleaseNotesBot.Users do
  @moduledoc """
  These are the Repo functions for Users
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.User

  def create(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(User)
  end

  # Get a note by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(User, param)
  end
end
