defmodule ReleaseNotesBot.Schema.Channel do
  @moduledoc """
  This module is used to model Slack Channels
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field(:name, :string)
    field(:slack_id, :string)
    belongs_to(:project, ReleaseNotesBot.Schema.Project)
    belongs_to(:client, ReleaseNotesBot.Schema.Client)

    timestamps()
  end

  def changeset(channel, params) do
    channel
    |> cast(params, [:project_id, :client_id, :name, :slack_id])
    |> validate_required([:name, :slack_id])
  end
end
