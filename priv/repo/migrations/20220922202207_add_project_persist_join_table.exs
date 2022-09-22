defmodule ReleaseNotesBot.Repo.Migrations.AddProjectProviderJoinTable do
  use Ecto.Migration

  def up do
    create table(:project_providers) do
      add(:project_id, references(:projects), null: false)
      add(:persistence_provider_id, references(:persistence_providers), null: false, default: 1)

      add(:config, :map,
        null: false,
        default: %{
          "space_id" => Application.get_env(:release_notes_bot, :confluence_space_id),
          "space_key" => Application.get_env(:release_notes_bot, :confluence_space_key),
          "parent_id" => Application.get_env(:release_notes_bot, :confluence_parent_id),
          "organization" => Application.get_env(:release_notes_bot, :confluence_organization)
        }
      )

      timestamps()
    end
  end

  def down do
    drop table(:project_providers)
  end
end
