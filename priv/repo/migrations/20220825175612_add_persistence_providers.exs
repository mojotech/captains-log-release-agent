defmodule ReleaseNotesBot.Repo.Migrations.AddPersistenceProviders do
  use Ecto.Migration

  def change do
    create table(:persistence_providers) do
      add(:name, :string, null: false)

      timestamps()
    end
  end
end
