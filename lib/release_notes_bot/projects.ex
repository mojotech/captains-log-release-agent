defmodule ReleaseNotesBot.Projects do
  @moduledoc """
  This module is used to model a Client Project.
  A Client Stakeholder can have 0 or many Projects.
  A Project can have 0 or many Notes.
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Project
  alias ReleaseNotesBot.Clients

  def create(params) do
    %Project{}
    |> Project.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(Project)
  end

  # Get a project by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(Project, param)
  end

  def parse_response(res_body) do
    parse_inner_response(res_body["view"]["state"]["values"])
  end

  defp parse_inner_response(%{"client-select" => selected_client, "create_project" => input}) do
    client_id =
      String.to_integer(selected_client["static_select-action"]["selected_option"]["value"])

    client = Clients.get(id: client_id)

    __MODULE__.create(%{
      "name" => input["input_action"]["value"],
      "client_id" => client_id
    })

    %{client: client.name, project: input["input_action"]["value"]}
  end

  defp parse_inner_response(%{"create_client" => input}) do
    client_name = input["input_action"]["value"]
    Clients.create(%{"name" => input["input_action"]["value"]})
    %{client: client_name}
  end

  # Parse the response from the first modal
  defp parse_inner_response(%{"client-select" => input}) do
    # Populate a static select for all projects under client id in here
    input["static_select-action"]["selected_option"]["value"]
    |> String.to_integer()
    |> ReleaseNotesBot.Clients.get_projects()
  end

  # Parse the response from the last modal
  defp parse_inner_response(raw_values) do
    project_id = raw_values["block-title"]["select-title-action"]["selected_option"]["value"]

    case __MODULE__.get(id: String.to_integer(project_id)) do
      nil ->
        nil

      # Handle an entry! - Create a note for the project
      proj ->
        details = %{
          project: proj.name,
          note_title: raw_values["block-name"]["input-name"]["value"],
          note_message: raw_values["block-note"]["input-notes"]["value"]
        }

        ReleaseNotesBot.Note.create(%{
          "project_id" => proj.id,
          "title" => details.note_title,
          "message" => details.note_message
        })

        case raw_values["block-here"]["checkbox-here"]["selected_options"] do
          [] ->
            nil

          _ ->
            details
        end
    end
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
