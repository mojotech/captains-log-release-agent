defmodule ReleaseNotesBot.Project.Test do
  use ExUnit.Case, async: true
  alias ReleaseNotesBot.Project

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ReleaseNotesBot.Repo)
    seed
  end

  @test_suites [
    # {Test Case, Expected result}
    {"Captains Log", true},
    {"", false},
    {6, false},
    {"4", true}
  ]

  for i <- @test_suites do
    macro = Macro.escape(i)

    test "Project changeset for #{elem(i, 0)}", state do
      test_case = unquote(macro)

      result =
        Project.changeset(%Project{}, %{
          "client_id" => state[:insert_id],
          "name" => elem(test_case, 0)
        })

      assert result.valid? == elem(test_case, 1)
    end
  end

  defp seed do
    {:ok, res} = ReleaseNotesBot.Client.create(%{"name" => "TestClient"})
    {:ok, insert_id: res.id}
  end
end
