defmodule ReleaseNotesBot.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:project_id, references(:projects))
      add(:slack_name, :string, null: false)
      add(:slack_id, :string, null: false)

      timestamps()
    end
  end
end
