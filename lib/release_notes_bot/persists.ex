defmodule ReleaseNotesBot.Persists do
  @moduledoc """
  Repo functions to persist
  """
  alias ReleaseNotesBot.Schema.Persist

  def sanitize(params) do
    %Persist{}
    |> Persist.changeset(params)
  end

  def parse_params(
        release_title,
        release_body,
        persistence_provider_id \\ 1,
        project_persist_config \\ %{}
      ) do
    case persistence_provider_id do
      # Confluence
      1 ->
        space_id =
          "#{project_persist_config["space_id"] || Application.get_env(:release_notes_bot, :confluence_space_id)}"

        space_key =
          "#{project_persist_config["space_key"] || Application.get_env(:release_notes_bot, :confluence_space_key)}"

        parent_id =
          "#{project_persist_config["parent_id"] || Application.get_env(:release_notes_bot, :confluence_parent_id)}"

        organization =
          "#{project_persist_config["organization"] || Application.get_env(:release_notes_bot, :confluence_organization)}"

        user = Application.get_env(:release_notes_bot, :confluence_email)
        apikey = Application.get_env(:release_notes_bot, :confluence_api_key)
        token = Base.encode64("#{user}:#{apikey}")
        endpoint_url = "https://#{organization}.atlassian.net/wiki/"
        release = Earmark.as_html!(release_body, %Earmark.Options{compact_output: true})

        sanitize(%{
          :title => release_title,
          :message => release,
          :space_id => space_id,
          :space_key => space_key,
          :parent_id => parent_id,
          :organization => organization,
          :endpoint_url => endpoint_url,
          :endpoint_persistence => endpoint_url <> "rest/api/content",
          :endpoint_source => endpoint_url <> "spaces/#{space_key}/pages/",
          :token => token
        })

      _ ->
        sanitize(%{})
    end
  end

  def persist(
        title,
        release,
        project_provider,
        action
      ) do
    sanitizer =
      parse_params(
        title,
        release,
        project_provider.persistence_provider_id,
        project_provider.config
      )

    if sanitizer.valid? do
      case choose_action(sanitizer.changes, action, project_provider.persistence_provider_id) do
        {:ok, endpoint} ->
          {:ok, endpoint}

        {:error, err} ->
          {:error, err}
      end
    else
      {:error, "Invalid params.. Could not sanitize.."}
    end
  end

  defp choose_action(sanitizer_changes, action, persistence_provider_id) do
    case action do
      "published" ->
        case create(persistence_provider_id, sanitizer_changes) do
          {:ok, res} ->
            {:ok, res}

          {:error, err} ->
            {:error, err}
        end

      "edited" ->
        case update(persistence_provider_id, sanitizer_changes) do
          {:ok, res} ->
            {:ok, res}

          {:error, err} ->
            {:error, err}
        end

      _ ->
        {:error, "Invalid action"}
    end
  end

  defp create(persistence_provider_id, sanitizer_changes) do
    case select_provider_to_persist(persistence_provider_id, sanitizer_changes) do
      {:ok, endpoint} ->
        {:ok, endpoint}

      {:error, message} ->
        {:error, message}
    end
  end

  defp update(persistence_provider_id, sanitizer_changes) do
    case select_provider_to_update(persistence_provider_id, sanitizer_changes) do
      {:ok, endpoint} ->
        {:ok, endpoint}

      {:error, message} ->
        {:error, message}
    end
  end

  def select_provider_to_persist(persistence_provider_id, sanitizer_changes) do
    case persistence_provider_id do
      # Confluence
      1 ->
        case persist_confluence_page(sanitizer_changes) do
          {:ok, endpoint} ->
            {:ok, endpoint}

          {:error, _} ->
            {:error, "Error persisting"}
        end

      _ ->
        {:error, "Invalid persistence provider"}
    end
  end

  def select_provider_to_update(persistence_provider_id, sanitizer_changes) do
    case persistence_provider_id do
      # Confluence
      1 ->
        case update_confluence_page(sanitizer_changes) do
          {:ok, endpoint} ->
            {:ok, endpoint}

          {:error, _} ->
            {:error, "Error updating"}
        end

      _ ->
        {:error, "Invalid persistence provider"}
    end
  end

  def persist_confluence_page(data) do
    headers = get_headers(%{"token" => data.token})

    body =
      create_confluence_body(
        data.title,
        data.space_id,
        data.space_key,
        data.parent_id,
        data.message
      )

    case Finch.request(
           Finch.build(
             :post,
             data.endpoint_persistence,
             headers,
             Jason.encode!(body)
           ),
           ReleaseNotesBot.Finch
         ) do
      {:ok, response} ->
        payload = Jason.decode!(response.body)
        # TO DO: Post Labels to Confluence Page - labels should be the project name
        # https://stackoverflow.com/questions/39013589/how-to-add-labels-to-confluence-page-via-rest
        {:ok,
         data.endpoint_source <>
           "#{payload["id"]}/#{data.title |> replace_spaces_with_plus_signs |> drop_question_mark}"}

      {:error, _reason} ->
        {:error, 500}
    end
  end

  defp update_confluence_page(data) do
    headers = get_headers(%{"token" => data.token})
    {:error, "Not implemented"}
  end

  # https://developer.atlassian.com/server/confluence/confluence-rest-api-examples/#create-a-new-page
  defp create_confluence_body(page_title, space_id, space_key, parent_id, page_text) do
    %{
      title: page_title,
      type: "page",
      space: %{
        id: space_id,
        key: space_key
      },
      status: "current",
      ancestors: [
        %{
          id: parent_id
        }
      ],
      body: %{
        storage: %{
          value: page_text,
          representation: "storage"
        }
      }
    }
  end

  defp replace_spaces_with_plus_signs(string), do: String.replace(string, " ", "+")

  defp drop_question_mark(string), do: String.replace(string, "?", "")

  defp get_headers(%{"token" => token}) do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Basic #{token}"}
    ]
  end
end
