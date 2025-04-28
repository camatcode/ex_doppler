defmodule ExDoppler.ConfigLogs do
  @moduledoc false

  alias ExDoppler.Config
  alias ExDoppler.ConfigLog
  alias ExDoppler.Util.Requester

  @config_logs_api_path "/v3/configs/config/logs"

  def list_config_logs(%Config{project: project_name, name: config_name}, opts \\ []) do
    qparams =
      Keyword.merge([page: 1, per_page: 20, project: project_name, config: config_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@config_logs_api_path, qparams: qparams) do
      page = body["page"]

      logs =
        body["logs"]
        |> Enum.map(&ConfigLog.build/1)

      {:ok, %{page: page, logs: logs}}
    end
  end

  def list_config_logs!(%Config{} = config, opts \\ []) do
    with {:ok, config_logs} <- list_config_logs(config, opts) do
      config_logs
    end
  end

  def get_config_log(%Config{project: project_name, name: config_name}, log_id)
      when is_bitstring(log_id) do
    path =
      @config_logs_api_path
      |> Path.join("/log")

    opts = [qparams: [project: project_name, config: config_name, log: log_id]]

    with {:ok, %{body: body}} <- Requester.get(path, opts) do
      {:ok, ConfigLog.build(body["log"])}
    end
  end

  def get_config_log!(%Config{} = config, log_id) do
    with {:ok, config_log} <- get_config_log(config, log_id) do
      config_log
    end
  end

  def rollback_config_log(%ConfigLog{project: project_name, config: config_name, id: log_id}) do
    path =
      @config_logs_api_path
      |> Path.join("/log/rollback")

    opts = [qparams: [project: project_name, config: config_name, log: log_id]]

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, ConfigLog.build(body["log"])}
    end
  end

  def rollback_config_log!(%ConfigLog{} = config_log) do
    with {:ok, log} <- rollback_config_log(config_log) do
      log
    end
  end
end
