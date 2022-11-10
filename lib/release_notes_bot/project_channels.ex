defmodule ReleaseNotesBot.ProjectChannels do
  @moduledoc """
  Repo functions for Project Channel
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.ProjectChannel

  def create(params) do
    %ProjectChannel{}
    |> ProjectChannel.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(ProjectChannel)
  end

  def get(param) do
    Repo.get_by(ProjectChannel, param)
  end
end
