defmodule ReleaseNotesBot.Schema.Client do
  @moduledoc """
  This module is used to model a Client Stakeholder.
  A client Stakeholder can have 0 or many projects.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field(:name, :string)
    has_many(:projects, ReleaseNotesBot.Schema.Project)
    has_many(:client_channels, ReleaseNotesBot.Schema.ClientChannel)

    timestamps()
  end

  def changeset(client, params) do
    client
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
