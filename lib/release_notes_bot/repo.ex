defmodule ReleaseNotesBot.Repo do
  use Ecto.Repo,
    otp_app: :release_notes_bot,
    adapter: Ecto.Adapters.Postgres
end
