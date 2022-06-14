defmodule ReleaseNotesBot.Clients do
  @moduledoc """
  Repo functions for Clients
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Client

  def create(params) do
    %Client{}
    |> Client.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(Client)
  end

  # Get a client by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(Client, param)
  end

  def get_projects(id) do
    Client
    |> Repo.get(id)
    |> Repo.preload([:projects])
  end
end
