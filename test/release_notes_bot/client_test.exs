defmodule ReleaseNotesBot.Client.Test do
  use ExUnit.Case, async: true
  alias ReleaseNotesBot.Client

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ReleaseNotesBot.Repo)
  end

  @test_suites [
    # {Test Case, Expected result}
    {"Rapidan", true},
    {4, false},
    {"6", true},
    {"", false}
  ]

  for i <- @test_suites do
    macro = Macro.escape(i)

    test "Client changeset for #{elem(i, 0)}" do
      test_case = unquote(macro)

      result =
        Client.changeset(%Client{}, %{
          "name" => elem(test_case, 0)
        })

      assert result.valid? == elem(test_case, 1)
    end
  end
end
