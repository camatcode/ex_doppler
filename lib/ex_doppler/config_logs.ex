defmodule ExDoppler.ConfigLogs do
  @moduledoc false

  alias ExDoppler.ConfigLog
  alias ExDoppler.Util.Requester

  @config_logs_api_path "/v3/configs/config/logs"

  def list_config_logs(project_name, config_name, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
    qparams =
      Keyword.merge([page: 1, per_page: 20, project: project_name, config: config_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@config_logs_api_path, qparams: qparams) do
      page = body["page"]

      logs =
        body["logs"]
        |> Enum.map(&ConfigLog.build_config_log/1)

      {:ok, %{page: page, logs: logs}}
    end
  end

  def get_config_log(project_name, config_name, log_id)
      when is_bitstring(project_name) and is_bitstring(config_name) and is_bitstring(log_id) do
    path =
      @config_logs_api_path
      |> Path.join("/log")

    opts = [qparams: [project: project_name, config: config_name, log: log_id]]

    with {:ok, %{body: body}} <- Requester.get(path, opts) do
      {:ok, ConfigLog.build_config_log(body["log"])}
    end
  end

  def rollback(project_name, config_name, log_id)
      when is_bitstring(project_name) and is_bitstring(config_name) and is_bitstring(log_id) do
    path =
      @config_logs_api_path
      |> Path.join("/log/rollback")

    opts = [qparams: [project: project_name, config: config_name, log: log_id]]

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, ConfigLog.build_config_log(body["log"])}
    end
  end
end
