defmodule ReleaseNotesBot.Repo.Migrations.CreateChannelUsersJoinTable do
  use Ecto.Migration

  def up do
    create table(:channel_users) do
      add(:channel_id, references(:channels), null: false)
      add(:user_id, references(:users), null: false)

      timestamps()
    end
  end

  def down do
    drop table(:channel_users)
  end
end
