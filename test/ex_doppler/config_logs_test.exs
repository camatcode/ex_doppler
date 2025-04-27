defmodule ExDoppler.ConfigLogsTest do
  use ExUnit.Case
  doctest ExDoppler.ConfigLogs

  alias ExDoppler.ConfigLogs
  alias ExDoppler.Configs
  alias ExDoppler.Projects

  test "config logs" do
    assert {:ok, %{projects: [project | _]}} = Projects.list_projects()
    assert {:ok, %{page: 1, configs: configs}} = Configs.list_configs(project)
    refute Enum.empty?(configs)

    configs
    |> Enum.each(fn config ->
      {:ok, %{page: 1, logs: logs}} =
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
        assert {:ok, log} == ConfigLogs.get_config_log(config, log.id)
      end)

      logs
      |> Enum.take(1)
      |> Enum.each(fn log ->
        ConfigLogs.rollback(log)
        |> case do
          {:ok, log} -> assert log.rollback
          _ -> :ok
        end
      end)
    end)
  end
end
