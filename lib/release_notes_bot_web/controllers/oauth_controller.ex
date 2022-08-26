defmodule ReleaseNotesBotWeb.OAuthController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller

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

    conn |> Plug.Conn.send_resp(200, "OK")
  end
end
