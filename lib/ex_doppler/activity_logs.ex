defmodule ExDoppler.ActivityLogs do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @activity_logs_api_path "/v3/logs"

  def list_activity_logs(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@activity_logs_api_path, qparams: opts) do
      page = body["page"]
      logs = body["logs"] |> Enum.map(&build_activity_log/1)
      {:ok, %{page: page, logs: logs}}
    end
  end

  def get_activity_log(id) when not is_nil(id) do
    path =
      @activity_logs_api_path
      |> Path.join("/log")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [log: id]) do
      {:ok, build_activity_log(body["log"])}
    end
  end

  defp build_activity_log(activity_log) do
    fields =
      activity_log
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ActivityLog, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:user, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.User, val)
  end

  defp serialize(:diff, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.ActivityDiff, val)
  end

  defp serialize(_, val), do: val
end
