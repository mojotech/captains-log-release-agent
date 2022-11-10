defmodule ReleaseNotesBot.Schema.ClientChannel do
  @moduledoc """
  This module is used to model a join table between Client and Slack Channel.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "client_channels" do
    belongs_to(:client, ReleaseNotesBot.Schema.Client)
    belongs_to(:channel, ReleaseNotesBot.Schema.Channel)

    timestamps()
  end

  def changeset(client_channel, params) do
    client_channel
    |> cast(params, [:client_id, :channel_id])
    |> validate_required([:client_id, :channel_id])
  end
end
