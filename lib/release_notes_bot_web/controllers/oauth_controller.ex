defmodule ReleaseNotesBotWeb.OAuthController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller
  import Ecto.Query, only: [from: 2]

  alias ReleaseNotesBot.Schema.{Token}
  alias ReleaseNotesBot.{Repo}

  def get(conn, params) do
    slack_id = params["state"]

    headers = [
      {"Content-Type", "application/json"}
    ]

    body = %{
      grant_type: "authorization_code",
      client_id: Application.get_env(:release_notes_bot, :client_id),
      client_secret: Application.get_env(:release_notes_bot, :client_secret),
      code: params["code"],
      redirect_uri: Application.get_env(:release_notes_bot, :oauth_redirect_uri)
    }

    {_status, json_body} = JSON.encode(body)

    tokens_response =
      HTTPoison.post!("https://auth.atlassian.com/oauth/token", json_body, headers)

    tokens_json = Jason.decode!(tokens_response.body)
    access_token = tokens_json["access_token"]
    refresh_token = tokens_json["refresh_token"]

    user_id = Repo.one(from q in "users", where: q.slack_id == ^slack_id, select: q.id)

    %Token{
      persistence_provider_id: 1,
      access_token: access_token,
      refresh_token: refresh_token,
      user_id: user_id
    }
    |> Repo.insert()

    conn |> Plug.Conn.send_resp(200, "OK")
  end
end
