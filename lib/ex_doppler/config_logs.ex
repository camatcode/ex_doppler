defmodule ExDoppler.ConfigLogs do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @config_logs_api_path "/v3/configs/config/logs"

  def list_config_logs(project_name, config_name, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
    opts =
      Keyword.merge([page: 1, per_page: 20, project: project_name, config: config_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@config_logs_api_path, qparams: opts) do
      page = body["page"]

      logs =
        body["logs"]
        |> Enum.map(&build_config_log/1)

      {:ok, %{page: page, logs: logs}}
    end
  end

  def get_config_log(project_name, config_name, log_id)
      when is_bitstring(project_name) and is_bitstring(config_name) do
    path =
      @config_logs_api_path
      |> Path.join("/log")

    with {:ok, %{body: body}} <-
           Requester.get(path, qparams: [project: project_name, config: config_name, log: log_id]) do
      {:ok, build_config_log(body["log"])}
    end
  end

  defp build_config_log(log) do
    fields =
      log
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ConfigLog, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:user, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.User, val)
  end

  defp serialize(_, val), do: val
end
