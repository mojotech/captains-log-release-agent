defmodule ReleaseNotesBot.Schema.Channel do
  @moduledoc """
  This module is used to model Slack Channels
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field(:name, :string)
    field(:slack_id, :string)
    has_many(:channel_users, ReleaseNotesBot.Schema.ChannelUser)
    has_many(:project_channels, ReleaseNotesBot.Schema.ProjectChannel)
    has_many(:client_channels, ReleaseNotesBot.Schema.ClientChannel)

    timestamps()
  end

  def changeset(channel, params) do
    channel
    |> cast(params, [:name, :slack_id])
    |> validate_required([:name, :slack_id])
  end
end
