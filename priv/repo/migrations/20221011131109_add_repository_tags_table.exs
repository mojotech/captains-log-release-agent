defmodule ReleaseNotesBot.Repo.Migrations.ChangeWebhookEventPayloadType do
  use Ecto.Migration

  def up do
    change_webhook_payload(:jsonb)
  end

  def down do
    change_webhook_payload(:string)
  end

  defp change_webhook_payload(type) do
    alter table(:webhook_events) do
      remove(:raw_payload)
    end

    alter table(:webhook_events) do
      add(:raw_payload, type, null: false)
    end
  end
end
