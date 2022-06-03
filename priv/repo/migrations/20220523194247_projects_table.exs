defmodule ReleaseNotesBot.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add(:client_id, references(:clients), null: false)
      add(:name, :string, null: false)

      timestamps()
    end
  end
end
