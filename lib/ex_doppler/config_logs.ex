defmodule ExDoppler.ConfigLogs do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def config_logs_api_path, do: "/v3/configs/config/logs"

  def list_config_logs(project_name, config_name, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    config_logs_api_path()
    |> Requester.get(
      qparams: [
        page: opts[:page],
        per_page: opts[:per_page],
        project: project_name,
        config: config_name
      ]
    )
    |> case do
      {:ok, %{body: body}} ->
        page = body["page"]

        logs =
          body["logs"]
          |> Enum.map(&build_config_log/1)

        {:ok, %{page: page, logs: logs}}

      err ->
        err
    end
  end

  def get_config_log(project_name, config_name, log_id) do
    config_logs_api_path()
    |> Path.join("/log")
    |> Requester.get(qparams: [project: project_name, config: config_name, log: log_id])
    |> case do
      {:ok, %{body: body}} ->
        {:ok, build_config_log(body["log"])}

      err ->
        err
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
