defmodule ReleaseNotesBot.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add(:project_id, references(:projects), null: false)
      add(:title, :string, null: false)
      add(:message, :string, null: false)

      timestamps()
    end
  end
end
