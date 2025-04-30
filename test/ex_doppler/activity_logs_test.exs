defmodule ExDoppler.ActivityLogsTest do
  use ExUnit.Case
  doctest ExDoppler.ActivityLogs

  alias ExDoppler.ActivityLogs

  test "activity logs" do
    assert {:ok, logs} = ActivityLogs.list_activity_logs()
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

      assert {:ok, log} == ActivityLogs.get_activity_log(log.id)
    end)
  end

  assert {:ok, [log]} = ActivityLogs.list_activity_logs(page: 2, per_page: 1)
  assert log.id
end
