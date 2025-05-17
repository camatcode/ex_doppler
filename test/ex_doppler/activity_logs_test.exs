defmodule ExDoppler.ActivityLogsTest do
  use ExUnit.Case

  alias ExDoppler.ActivityLogs

  doctest ExDoppler.ActivityLogs

  test "list_activity_logs/1 and get_activity_log/1" do
    assert {:ok, logs} = ActivityLogs.list_activity_logs()
    refute Enum.empty?(logs)

    Enum.each(logs, fn log ->
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

      assert log == ActivityLogs.get_activity_log!(log.id)
    end)

    [log] = ActivityLogs.list_activity_logs!(page: 2, per_page: 1)
    assert log.id
  end
end
