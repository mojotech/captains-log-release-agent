defmodule ReleaseNotesBot.Factory do
  @moduledoc """
  This module provides factory functions for building and inserting data.
  """

  use ExMachina.Ecto, repo: ReleaseNotesBot.Repo
  alias ReleaseNotesBot.Schema.{Client, Note, Project, ProjectProvider, PersistenceProvider}

  def client_factory do
    %Client{
      name: "Mojotech"
    }
  end

  def persistence_provider_factory do
    %PersistenceProvider{
      name: "Confluence"
    }
  end

  def project_provider_factory do
    %ProjectProvider{
      persistence_provider: build(:persistence_provider)
    }
  end

  def project_factory do
    %Project{
      name: "Captain's Log",
      client: build(:client),
      project_provider: [build(:project_provider)]
    }
  end

  def note_factory do
    %Note{
      title: sequence("Test Note "),
      message: "#{sequence("- feature ")}\n#{sequence("- bug fix ")}",
      project: build(:project)
    }
  end

  def insert_seeds do
    insert(:note)
  end
end
