defmodule ExDoppler.ConfigLogsTest do
  use ExUnit.Case
  doctest ExDoppler.ConfigLogs

  alias ExDoppler.ConfigLogs
  alias ExDoppler.Configs

  test "config logs" do
    {:ok, %{page: 1, configs: configs}} = Configs.list_configs()
    refute Enum.empty?(configs)

    configs
    |> Enum.each(fn config ->
      {:ok, %{page: 1, logs: logs}} =
        ConfigLogs.list_config_logs(config.project, config.name)

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

        assert {:ok, log} == ConfigLogs.get_config_log(log.project, log.config, log.id)
      end)
    end)
  end
end
