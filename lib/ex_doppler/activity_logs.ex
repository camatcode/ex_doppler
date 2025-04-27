defmodule ExDoppler.ActivityLogs do
  @moduledoc false

  alias ExDoppler.ActivityLog
  alias ExDoppler.Util.Requester

  @activity_logs_api_path "/v3/logs"

  def list_activity_logs(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@activity_logs_api_path, qparams: opts) do
      page = body["page"]
      logs = body["logs"] |> Enum.map(&ActivityLog.build_activity_log/1)
      {:ok, %{page: page, logs: logs}}
    end
  end

  def get_activity_log(id) when is_bitstring(id) do
    path =
      @activity_logs_api_path
      |> Path.join("/log")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [log: id]) do
      {:ok, ActivityLog.build_activity_log(body["log"])}
    end
  end
end
