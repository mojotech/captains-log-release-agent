defmodule ReleaseNotesBotWeb.OAuthController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller

  def get(conn, params) do
    conn |> Plug.Conn.send_resp(200, "OK")
  end
end
