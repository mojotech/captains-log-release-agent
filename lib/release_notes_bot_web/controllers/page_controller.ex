defmodule ReleaseNotesBotWeb.PageController do
  use ReleaseNotesBotWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
