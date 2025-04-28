defmodule ExDoppler.ActivityLogs do
  @moduledoc """
      Module for interacting with Doppler Activity Logs

      Doppler API Doc: https://docs.doppler.com/reference/activity_logs-object
  """

  alias ExDoppler.ActivityLog
  alias ExDoppler.Util.Requester

  @activity_logs_api_path "/v3/logs"

  def list_activity_logs(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@activity_logs_api_path, qparams: opts) do
      page = body["page"]
      logs = body["logs"] |> Enum.map(&ActivityLog.build/1)
      {:ok, %{page: page, logs: logs}}
    end
  end

  def list_activity_logs!(opts \\ []) do
    with {:ok, activity_logs} <- list_activity_logs(opts) do
      activity_logs
    end
  end

  def get_activity_log(id) when is_bitstring(id) do
    path =
      @activity_logs_api_path
      |> Path.join("/log")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [log: id]) do
      {:ok, ActivityLog.build(body["log"])}
    end
  end

  def get_activity_log!(id) do
    with {:ok, activity_log} <- get_activity_log(id) do
      activity_log
    end
  end
end
