defmodule ReleaseNotesBot.Projects do
  @moduledoc """
  This module is used to model a Client Project.
  A Client Stakeholder can have 0 or many Projects.
  A Project can have 0 or many Notes.
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Project
  alias ReleaseNotesBot.{Clients, Channels}

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

  def parse_response(view) do
    parse_inner_response(view["state"]["values"])
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

  defp parse_inner_response(%{"client-select" => input}) do
    # Slack Channel ID is encoded in the only key. We need to decode it.
    # It looks like this: "static_select-action:SOME-ID".
    # This key is used to update the Channels table so that way a client_id
    # is always associated with a particular channel.
    [key] = Map.keys(input)
    slack_channel = String.split(key, ":") |> List.last()
    client_id = String.to_integer(input[key]["selected_option"]["value"])

    Channels.update(
      Channels.get(slack_id: slack_channel),
      %{client_id: client_id}
    )

    client = Clients.get(id: client_id)
    %{client: client.name, channel: slack_channel}
  end

  defp parse_inner_response(raw_values) do
    project_id = raw_values["block-title"]["select-title-action"]["selected_option"]["value"]

    case __MODULE__.get(id: String.to_integer(project_id)) do
      nil ->
        nil

      # Handle an entry! - Create a note for the project
      proj ->
        details = %{
          project: proj.name,
          title: raw_values["block-name"]["input-name"]["value"],
          message: raw_values["block-note"]["input-notes"]["value"]
        }

        details = Map.put_new(details, :persistence_status, ReleaseNotesBot.Note.persist(details))

        ReleaseNotesBot.Note.create(%{
          "project_id" => proj.id,
          "title" => details.title,
          "message" => details.message,
          "persisted" => interpret_persisted(details.persistence_status)
        })

        case raw_values["block-here"]["checkbox-here"]["selected_options"] do
          [] ->
            nil

          _ ->
            %{details: details, client: Clients.get_channels(proj.client_id)}
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

  defp interpret_persisted(status) do
    case status do
      200 ->
        true

      _ ->
        false
    end
  end
end
