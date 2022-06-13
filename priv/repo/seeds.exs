# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ReleaseNotesBot.Repo.insert!(%ReleaseNotesBot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import ReleaseNotesBot.Factory
alias ReleaseNotesBot.Note

Note.get(id: 1) || insert_test()
