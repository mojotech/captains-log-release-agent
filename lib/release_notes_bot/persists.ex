defmodule ReleaseNotesBot.Persists do
  @moduledoc """
  Repo functions to persist
  """
  alias ReleaseNotesBot.Schema.Persist

  def sanitize(params) do
    %Persist{}
    |> Persist.changeset(params)
  end

  def persist(
        title,
        release,
        space_parent_id \\ Application.get_env(:release_notes_bot, :confluence_parent_id)
      ) do
    space_id = Application.get_env(:release_notes_bot, :confluence_space_id)
    space_key = Application.get_env(:release_notes_bot, :confluence_space_key)
    parent_id = space_parent_id
    user = Application.get_env(:release_notes_bot, :confluence_email)
    apikey = Application.get_env(:release_notes_bot, :confluence_api_key)
    organization = "mojotech"
    endpoint_url = "https://#{organization}.atlassian.net/wiki/"
    endpoint_persistence = endpoint_url <> "rest/api/content"
    endpoint_source = endpoint_url <> "spaces/#{space_key}/pages/#{parent_id}/#{title}"
    token = Base.encode64("#{user}:#{apikey}")
    release = Earmark.as_html!(release, %Earmark.Options{compact_output: true})

    r =
      sanitize(%{
        :title => "#{title}",
        :message => "#{release}",
        :space_id => "#{space_id}",
        :space_key => "#{space_key}",
        :parent_id => "#{parent_id}",
        :organization => "#{organization}",
        :endpoint_url => "#{endpoint_url}",
        :endpoint_persistence => "#{endpoint_persistence}",
        :endpoint_source => "#{endpoint_source}",
        :token => "#{token}"
      })

    if r.valid? == true do
      headers = [{"Content-Type", "application/json"}, {"Authorization", "Basic #{token}"}]
      body = create_body(title, space_id, space_key, parent_id, release)

      case Finch.request(
             Finch.build(
               :post,
               endpoint_persistence,
               headers,
               Jason.encode!(body)
             ),
             ReleaseNotesBot.Finch
           ) do
        {:ok, response} ->
          response.status

        {:error, _reason} ->
          500
      end
    else
      400
    end
  end

  # https://developer.atlassian.com/server/confluence/confluence-rest-api-examples/#create-a-new-page
  defp create_body(page_title, space_id, space_key, parent_id, page_text) do
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
end
