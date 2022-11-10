defmodule ReleaseNotesBot.Schema.ChannelUser do
  @moduledoc """
  This module is used to model a join table between User and Slack Channel.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "channel_users" do
    belongs_to(:user, ReleaseNotesBot.Schema.User)
    belongs_to(:channel, ReleaseNotesBot.Schema.Channel)

    timestamps()
  end

  def changeset(channel_user, params) do
    channel_user
    |> cast(params, [:user_id, :channel_id])
    |> validate_required([:user_id, :channel_id])
  end
end
