defmodule ReleaseNotesBot.Client do
  @moduledoc """
  This module is used to model a Client Stakeholder.
  A client Stakeholder can have 0 or many projects.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias ReleaseNotesBot.Repo
  alias __MODULE__

  schema "clients" do
    field(:name, :string)
    has_many(:projects, ReleaseNotesBot.Project)

    timestamps()
  end

  def changeset(client, params) do
    client
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def create(params) do
    %Client{}
    |> changeset(params)
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
end
