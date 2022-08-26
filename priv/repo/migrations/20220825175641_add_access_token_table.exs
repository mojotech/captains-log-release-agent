defmodule ReleaseNotesBot.Repo.Migrations.AddAccessTokenTable do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add(:access_token, :text, null: false)
      add(:refresh_token, :text, null: false)
      add(:persistence_provider_id, references(:persistence_providers))
      add(:user_id, references(:users))

      timestamps()
    end
  end
end
