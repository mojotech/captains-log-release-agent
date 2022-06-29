defmodule ReleaseNotesBot.Factory do
  @moduledoc """
  This module provides factory functions for building and inserting data.
  """

  use ExMachina.Ecto, repo: ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.{Client, Note, Project}

  def client_factory do
    %Client{
      name: sequence("Client ")
    }
  end

  def project_factory do
    %Project{
      name: sequence("Project "),
      client: build(:client)
    }
  end

  def note_factory do
    %Note{
      title: sequence("Title "),
      message: "#{sequence("- feature ")}\n#{sequence("- bug fix ")}",
      project: build(:project)
    }
  end

  def insert_test do
    insert(:note)
    insert(:note)
  end
end
