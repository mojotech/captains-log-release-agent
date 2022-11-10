defmodule ReleaseNotesBot.Schema.ProjectChannel do
  @moduledoc """
  This module is used to model a join table between Project and Slack Channel.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_channels" do
    belongs_to(:project, ReleaseNotesBot.Schema.Project)
    belongs_to(:channel, ReleaseNotesBot.Schema.Channel)

    timestamps()
  end

  def changeset(project_channel, params) do
    project_channel
    |> cast(params, [:project_id, :channel_id])
    |> validate_required([:project_id, :channel_id])
  end
end
