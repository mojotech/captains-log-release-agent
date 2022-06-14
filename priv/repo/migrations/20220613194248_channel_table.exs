defmodule ReleaseNotesBot.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:project_id, references(:projects))
      add(:client_id, references(:clients))
      add(:name, :string, null: false)
      add(:slack_id, :string, null: false)

      timestamps()
    end
  end
end
