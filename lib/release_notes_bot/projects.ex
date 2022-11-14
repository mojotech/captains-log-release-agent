defmodule ReleaseNotesBot.Projects do
  @moduledoc """
  This module is used to model a Client Project.
  A Client Stakeholder can have 0 or many Projects.
  A Project can have 0 or many Notes.
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.{Project, Channel}

  alias ReleaseNotesBot.{
    Clients,
    Channels,
    Repositories,
    Note,
    Persists,
    ProjectProviders,
    PersistenceProviders,
    ProjectChannels
  }

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

  def get_provider(param) do
    Project
    |> Repo.get_by(param)
    |> Repo.preload([:project_provider])
  end

  def get_channels(param) do
    Project
    |> Repo.get_by(param)
    |> Repo.preload([:project_channels])
  end

  # All modal submissions pass through this function
  def parse_response(view) do
    parse_inner_response(view["state"]["values"])
  end

  # Handles modal submission for creating a new project
  defp parse_inner_response(%{
         "client-select" => selected_client,
         "create_project" => input,
         "repo-url" => repo_input,
         "project-provider" => provider_input
       }) do
    client_id =
      String.to_integer(selected_client["static_select-action"]["selected_option"]["value"])

    # !!!!!!!!
    # We may have to encode the slack channel id here unless we maintain client/channel relation
    # then propogate the project/channel relation
    client = Clients.get_channels(client_id)
    project_name = input["input_action"]["value"]

    {:ok, new_project} =
      create(%{
        "name" => project_name,
        "client_id" => client_id
      })

    if provider_input["project-provider-input"]["value"] != nil do
      PersistenceProviders.parse_url_and_create(
        provider_input["project-provider-input"]["value"],
        new_project.id
      )
    else
      ProjectProviders.create_default(new_project.id)
    end

    github_repo_url =
      Repositories.find_or_create_by_slack(new_project.id, repo_input["repo-url-input"]["value"])

    %{
      client: client,
      project: project_name,
      peristence: provider_input["project-provider-input"]["value"],
      add_webhook: github_repo_url
    }
  end

  # Handles modal submission for creating a new client
  defp parse_inner_response(%{"create_client" => input}) do
    client_name = input["input_action"]["value"]
    Clients.create(%{"name" => input["input_action"]["value"]})
    %{client: client_name}
  end

  # Handles modal submission where user assigns a client to a channel
  defp parse_inner_response(%{"client-select" => input}) do
    # Slack Channel ID is encoded in the only key. We need to decode it.
    # It looks like this: "static_select-action:SOME-ID".
    # This key is used to update the Channels table so that way a client_id
    # is always associated with a particular channel.
    [key] = Map.keys(input)
    slack_channel = String.split(key, ":") |> List.last()
    client_id = String.to_integer(input[key]["selected_option"]["value"])
    client = Clients.get_projects(id: client_id)

    # Create an entry inside of the ProjectChannel table
    # We need the channel id and the project id
    # For all projects under a client, create an entry for those projects
    # !!!!!

    # Maintain the client and channels relation for edge cases:
    # 1. where a new projcet is created after client assignment
    # TO DO: make this a many to many relationship with a join table
    Channels.update(
      Channels.get(slack_id: slack_channel),
      %{client_id: client_id}
    )

    %Channel{:id => id} = Channels.get(slack_id: slack_channel)

    IO.inspect("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    Enum.each(client.projects, fn project ->
      Task.async(fn ->
        ProjectChannels.create(%{
          :project_id => project.id,
          :channel_id => id
        })
      end |> IO.inspect)
    end)
    IO.inspect("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

    %{client: client.name, channel: slack_channel}
  end

  # Handles modal submission for manual release note creation
  defp parse_inner_response(raw_values) do
    project_id = raw_values["block-title"]["select-title-action"]["selected_option"]["value"]

    case __MODULE__.get_provider(id: String.to_integer(project_id)) do
      nil ->
        nil

      # Handle an entry! - Create a note for the project
      proj ->
        details = %{
          project: proj.name,
          title: raw_values["block-name"]["input-name"]["value"],
          message: raw_values["block-note"]["input-notes"]["value"]
        }

        # Persist the note
        endpoint = determine_persisted(details, proj.project_provider)

        details =
          Map.put_new(
            details,
            :persistence_url,
            endpoint
          )

        Note.create(%{
          "project_id" => proj.id,
          "title" => details.title,
          "message" => details.message,
          "persisted" => interpret_persisted(endpoint)
        })

        case raw_values["block-here"]["checkbox-here"]["selected_options"] do
          [] ->
            nil

          _ ->
            %{details: details, client: Clients.get_channels(proj.client_id)}
        end
    end
  end

  def determine_persisted(details, project_provider) do
    case Persists.persist(
           details.title,
           details.message,
           Enum.take(project_provider, 1) |> List.first(),
           "published"
         ) do
      {:ok, endpoint} ->
        endpoint

      _ ->
        nil
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
      nil ->
        false

      _ ->
        true
    end
  end
end
