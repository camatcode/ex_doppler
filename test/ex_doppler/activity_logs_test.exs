defmodule ExDoppler.ActivityLogsTest do
  use ExUnit.Case
  doctest ExDoppler.ActivityLogs

  alias ExDoppler.ActivityLogs

  test "activity logs" do
    assert {:ok, %{page: 1, logs: logs}} = ActivityLogs.list_activity_logs()
    refute Enum.empty?(logs)

    logs
    |> Enum.each(fn log ->
      assert log.created_at
      assert log.html
      assert log.id
      assert log.text
      assert log.user

      if log.diff do
        assert log.diff.added
        assert log.diff.removed
        assert log.diff.updated
      end
    end)
  end
end
