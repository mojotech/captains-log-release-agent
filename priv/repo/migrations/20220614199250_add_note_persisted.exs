defmodule ReleaseNotesBot.Repo.Migrations.AddPersistedFlagToNote do
  use Ecto.Migration

  def up do
    alter table(:notes) do
      add(:persisted, :boolean, default: false)
    end
  end

  def down do
    alter table(:notes) do
      remove(:persisted)
    end
  end
end
