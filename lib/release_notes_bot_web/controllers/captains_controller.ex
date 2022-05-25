defmodule ReleaseNotesBotWeb.CaptainsController do
  @moduledoc """
  This module will be responsible for consuming
  / commands from Slack.
  """
  use ReleaseNotesBotWeb, :controller

  def ping(conn, _params) do
    render(conn, "ping.json")
  end

  def new_client(conn, params) do
    case ReleaseNotesBot.Client.create(params) do
      {:ok, res} ->
        render(conn, "postResponse.json", data: res)

      {:error, changeset} ->
        render(conn, "postErrorResponse.json", data: changeset)
    end
  end

  def new_project(conn, params) do
    case ReleaseNotesBot.Project.create(params) do
      {:ok, res} ->
        render(conn, "postResponse.json", data: res)

      {:error, changeset} ->
        render(conn, "postErrorResponse.json", data: changeset)
    end
  end

  def new_note(conn, params) do
    case ReleaseNotesBot.Note.create(params) do
      {:ok, res} ->
        render(conn, "postResponse.json", data: res)

      {:error, changeset} ->
        render(conn, "postErrorResponse.json", data: changeset)
    end
  end
end
