defmodule ReleaseNotesBot.Note do
  @moduledoc """
  Repo functions for Notes
  """
  alias ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.Note

  def create(params) do
    %Note{}
    |> Note.changeset(params)
    |> Repo.insert()
  end

  def get_all do
    Repo.all(Note)
  end

  # Get a note by one specific field
  # param ex: (name: "mojotech") or (id: 4)
  def get(param) do
    Repo.get_by(Note, param)
  end

  # Let user know error code
  # Let user know success
  # Encode base64 function
  # Persist error codes to note
  def persist(note) do
    space_id = Application.get_env(:release_notes_bot, :confluence_space_id)
    space_key = Application.get_env(:release_notes_bot, :confluence_space_key)
    parent_id = Application.get_env(:release_notes_bot, :confluence_parent_id)
    user = Application.get_env(:release_notes_bot, :confluence_email)
    apikey = Application.get_env(:release_notes_bot, :confluence_api_key)

    token = Base.encode64("#{user}:#{apikey}")

    headers = [{"Content-Type", "application/json"}, {"Authorization", "Basic #{token}"}]

    body = create_body(note.title, space_id, space_key, parent_id, note.message)

    {:ok, response} =
      Finch.build(
        :post,
        "https://mojotech.atlassian.net/wiki/rest/api/content",
        headers,
        Jason.encode!(body)
      )
      |> Finch.request(ReleaseNotesBot.Finch)

    case response.status do
      # Successful persistence to 3rd party
      200 ->
        200

      # Failed persistence to 3rd party
      _ ->
        response.status
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
