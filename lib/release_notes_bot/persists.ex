defmodule ReleaseNotesBot.Persists do
  @moduledoc """
  Repo functions to persist
  """
  alias ReleaseNotesBot.Schema.Persist

  def sanitize(params) do
    %Persist{}
    |> Persist.changeset(params)
  end

  def persist(title, release) do
    space_id = Application.get_env(:release_notes_bot, :confluence_space_id)
    space_key = Application.get_env(:release_notes_bot, :confluence_space_key)
    parent_id = Application.get_env(:release_notes_bot, :confluence_parent_id)
    user = Application.get_env(:release_notes_bot, :confluence_email)
    apikey = Application.get_env(:release_notes_bot, :confluence_api_key)
    token = Base.encode64("#{user}:#{apikey}")

    r =
      sanitize(%{
        :title => "#{title}",
        :message => "#{release}",
        :space_id => "#{space_id}",
        :space_key => "#{space_key}",
        :parent_id => "#{parent_id}",
        :token => "#{token}"
      })

    if r.valid? == true do
      headers = [{"Content-Type", "application/json"}, {"Authorization", "Basic #{token}"}]
      body = create_body(title, space_id, space_key, parent_id, release)

      case Finch.request(
             Finch.build(
               :post,
               "https://mojotech.atlassian.net/wiki/rest/api/content",
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
          value: "<p>#{page_text}</p>",
          representation: "storage"
        }
      }
    }
  end
end
