defmodule ReleaseNotesBot.Schema.User do
  @moduledoc """
  This module is used to model Project Users
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:slack_name, :string)
    field(:slack_id, :string)
    belongs_to(:project, ReleaseNotesBot.Schema.Project)

    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, [:project_id, :slack_id, :slack_name])
    |> validate_required([:project_id, :slack_id, :slack_name])
  end
end
