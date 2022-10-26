defmodule ReleaseNotesBot.Repo.Migrations.CreateWebhookEventPersistencesTable do
  use Ecto.Migration

  def up do
    create table(:webhook_event_persistences) do
      add(:webhook_event_id, references(:webhook_events), null: false)
      add(:persistence_provider_id, references(:persistence_providers), null: false)
      add(:slug, :string, null: false)
      add(:version, :integer)

      timestamps()
    end
  end

  def down do
    drop table(:webhook_event_persistences)
  end
end
