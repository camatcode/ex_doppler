defmodule ExDoppler.ConfigLogsTest do
  use ExUnit.Case
  doctest ExDoppler.ConfigLogs

  alias ExDoppler.ConfigLogs
  alias ExDoppler.Configs
  alias ExDoppler.Projects

  test "list_config_logs/2 and get_config_log/2" do
    assert [project | _] = Projects.list_projects!()
    assert configs = Configs.list_configs!(project)
    refute Enum.empty?(configs)

    configs
    |> Enum.each(fn config ->
      {:ok, logs} =
        ConfigLogs.list_config_logs(config)

      logs
      |> Enum.each(fn log ->
        assert log.config
        assert log.created_at
        assert log.environment
        assert log.html
        assert log.id
        assert log.project
        assert log.rollback != nil
        assert log.text
        assert log.user
        assert log == ConfigLogs.get_config_log!(config, log.id)
      end)
    end)
  end

  test "rollback_config_log/1" do
    assert [project | _] = Projects.list_projects!()
    assert configs = Configs.list_configs!(project)
    refute Enum.empty?(configs)

    configs
    |> Enum.each(fn config ->
      ConfigLogs.list_config_logs!(config)
      |> Enum.take(1)
      |> Enum.each(fn log ->
        ConfigLogs.rollback_config_log(log)
        |> case do
          {:ok, log} -> assert log.rollback
          _ -> :ok
        end
      end)
    end)
  end
end
