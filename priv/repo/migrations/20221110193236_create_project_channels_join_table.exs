defmodule ReleaseNotesBot.Repo.Migrations.CreateProjectChannelsJoinTable do
  use Ecto.Migration

  def up do
    alter table(:channels) do
      remove(:project_id)
      remove(:client_id)
    end

    create table(:project_channels) do
      add(:project_id, references(:projects), null: false)
      add(:channel_id, references(:channels), null: false)

      timestamps()
    end

    create table(:client_channels) do
      add(:client_id, references(:clients), null: false)
      add(:channel_id, references(:channels), null: false)

      timestamps()
    end
  end

  def down do
    drop table(:project_channels)
    drop table(:client_channels)

    alter table(:channels) do
      add(:project_id, references(:projects), null: false)
      add(:client_id, references(:clients), null: false)
    end
  end
end
