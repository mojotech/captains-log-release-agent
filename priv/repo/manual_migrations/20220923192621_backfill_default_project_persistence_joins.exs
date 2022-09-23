defmodule ReleaseNotesBot.Repo.Migrations.BackfillDefaultProjectPersistenceJoins do
  @moduledoc """
  Backfill default project_persist joins

  This migration also introduces a new `ManualMigrations` module space for
  migrations that should not run automatically on deploy. Instead we can
  trigger these migrations via:
  ```
  mix ecto.migrate --migrations-path=priv/repo/manual_migrations
  ```
  For more details see [1] and [2].
  [1]: https://dashbit.co/blog/automatic-and-manual-ecto-migrations
  [2]: https://fly.io/phoenix-files/backfilling-data/
  """

  use Ecto.Migration
  import Ecto.Query

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    confluence_provider =
      ReleaseNotesBot.Repo.query!(
        "SELECT * from persistence_providers WHERE name LIKE 'Confluence';"
      ) || insert_persistence_provider()

    insert_defaults(confluence_provider)
  end

  def down, do: :ok

  def insert_defaults(%Postgrex.Result{rows: [row]}) do
    projects = ReleaseNotesBot.Repo.all(ReleaseNotesBot.Schema.Project)

    Enum.each(projects, fn project ->
      ReleaseNotesBot.Repo.insert!(%ReleaseNotesBot.Schema.ProjectProvider{
        project_id: project.id,
        persistence_provider_id: Enum.take(row, 1) |> List.first(),
        config: %{
          "space_id" => Application.get_env(:release_notes_bot, :confluence_space_id),
          "space_key" => Application.get_env(:release_notes_bot, :confluence_space_key),
          "parent_id" => Application.get_env(:release_notes_bot, :confluence_parent_id),
          "organization" => Application.get_env(:release_notes_bot, :confluence_organization)
        }
      })
    end)
  end

  def insert_persistence_provider() do
    ReleaseNotesBot.Repo.insert(%ReleaseNotesBot.Schema.PersistenceProvider{
      name: "Confluence"
    })
  end
end
