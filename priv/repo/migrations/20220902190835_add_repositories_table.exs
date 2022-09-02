defmodule ReleaseNotesBot.Repo.Migrations.AddRepositoriesTable do
  use Ecto.Migration

  def up do
    create table(:repositories) do
      add(:project_id, references(:projects))
      add(:url, :string, null: false)
      add(:name, :string)
      add(:full_name, :string)
      add(:observed_id, :string)
      add(:is_active, :boolean, default: true)

      timestamps()
    end
  end

  def down do
    drop table(:repositories)
  end
end
