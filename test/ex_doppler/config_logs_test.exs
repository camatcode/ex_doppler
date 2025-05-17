defmodule ExDoppler.ConfigLogsTest do
  use ExUnit.Case

  alias ExDoppler.ConfigLogs
  alias ExDoppler.Configs
  alias ExDoppler.Projects

  doctest ExDoppler.ConfigLogs

  test "list_config_logs/2 and get_config_log/2" do
    assert [project | _] = Projects.list_projects!()
    assert configs = Configs.list_configs!(project)
    refute Enum.empty?(configs)

    Enum.each(configs, fn config ->
      {:ok, logs} =
        ConfigLogs.list_config_logs(config)

      Enum.each(logs, fn log ->
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

    Enum.each(configs, fn config ->
      config
      |> ConfigLogs.list_config_logs!()
      |> Enum.take(1)
      |> Enum.each(fn log ->
        log
        |> ConfigLogs.rollback_config_log()
        |> case do
          {:ok, log} -> assert log.rollback
          _ -> :ok
        end
      end)
    end)
  end
end
