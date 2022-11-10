defmodule ReleaseNotesBot.ClientChannels do
  @moduledoc """
  Repo functions for Client Channel
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.ClientChannel

  def create(params) do
    %ClientChannel{}
    |> ClientChannel.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(ClientChannel)
  end

  def get(param) do
    Repo.get_by(ClientChannel, param)
  end
end
