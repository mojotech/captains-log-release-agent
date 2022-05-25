defmodule ReleaseNotesBot.Project do
  @moduledoc """
  This module is used to model a Client Project.
  A Client Stakeholder can have 0 or many Projects.
  A Project can have 0 or many Notes.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias ReleaseNotesBot.Repo

  schema "projects" do
    field(:name, :string)
    belongs_to(:client, ReleaseNotesBot.Client)
    has_many(:notes, ReleaseNotesBot.Note)

    timestamps()
  end

  def changeset(project, params) do
    project
    |> cast(params, [:client_id, :name])
    |> validate_required([:client_id, :name])
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(__MODULE__)
  end

  # Get a project by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(__MODULE__, param)
  end

  def parse_response(res_body) do
    parse_inner_response(res_body["view"]["state"]["values"])
  end

  # Parse the response from the first modal
  defp parse_inner_response(%{"client-select" => input}) do
    # Populate a static select for all projects under client id in here
    input["static_select-action"]["selected_option"]["value"]
    |> String.to_integer()
    |> ReleaseNotesBot.Client.get_projects()
  end

  # Parse the response from the last modal
  defp parse_inner_response(raw_values) do
    project_id = raw_values["block-title"]["select-title-action"]["selected_option"]["value"]

    case __MODULE__.get(id: String.to_integer(project_id)) do
      nil ->
        nil

      # Handle an entry! - Create a note for the project
      proj ->
        ReleaseNotesBot.Note.create(%{
          "project_id" => proj.id,
          "title" => raw_values["block-name"]["input-name"]["value"],
          "message" => raw_values["block-note"]["input-notes"]["value"]
        })
    end

    ## Notify Channel based on
    raw_values["block-here"]["checkbox-here"]["selected_options"]
  end

  def parse_params(%{"payload" => load}) when is_binary(load) do
    {:ok, res} = Jason.decode(load)
    res
  end

  def parse_params(params = %{}) do
    params
  end

  # parse_action can reduced to regular pattern matching in calling function
  def parse_action(%{"type" => "view_submission"}) do
    "view_submission"
  end

  def parse_action(%{"type" => "view_closed"}) do
    "view_closed"
  end

  def parse_action(%{}) do
    "open_modal"
  end
end
