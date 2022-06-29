defmodule ReleaseNotesBot.Channels do
  @moduledoc """
  These are the Repo functions for Channels
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Channel

  def create(params) do
    %Channel{}
    |> Channel.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(Channel)
  end

  # Get a note by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(Channel, param)
  end
end
