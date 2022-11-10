defmodule ReleaseNotesBot.ChannelUsers do
  @moduledoc """
  Repo functions for Project Channel
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.ChannelUser

  def create(params) do
    %ChannelUser{}
    |> ChannelUser.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(ChannelUser)
  end

  def get(param) do
    Repo.get_by(ChannelUser, param)
  end
end
