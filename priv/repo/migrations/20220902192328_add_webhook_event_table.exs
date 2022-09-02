defmodule ReleaseNotesBot.Repo.Migrations.AddWebhookEventTable do
  use Ecto.Migration

  def up do
    create table(:webhook_events) do
      add(:repository_id, references(:repositories), null: false)
      add(:raw_payload, :string, null: false)

      timestamps()
    end
  end

  def down do
    drop table(:webhook_events)
  end
end
