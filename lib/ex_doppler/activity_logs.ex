# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ActivityLogs do
  @moduledoc """
  Module for interacting with `ExDoppler.ActivityLog`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources_block("workplace-logs#activity-logs", "activity_logs-object")}

  <!-- tabs-close -->
  """

  alias ExDoppler.ActivityLog
  alias ExDoppler.Util.Requester

  @activity_logs_api_path "/v3/logs"

  @doc """
  Lists `ExDoppler.ActivityLog` using pagination.

  <!-- tabs-open -->

  ### Params
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.ActivityLog` to return for this page (e.g `per_page: 50`). Default: `20`

  #{ExDoppler.Doc.returns_block(success: "{:ok, [%ExDoppler.ActivityLog{...} ...]}", failure: "{:err, err}")}

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/activity_logs-list){:target="_blank"}

  <!-- tabs-close -->
  """
  def list_activity_logs(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@activity_logs_api_path, qparams: opts) do
      logs = body["logs"] |> Enum.map(&ActivityLog.build/1)
      {:ok, logs}
    end
  end

  @doc """
  Same as `list_activity_logs/1` but won't wrap a successful response in `{:ok, response}`
  """
  def list_activity_logs!(opts \\ []) do
    with {:ok, activity_logs} <- list_activity_logs(opts) do
      activity_logs
    end
  end

  @doc """
  Retrieves an `ExDoppler.ActivityLog`

  <!-- tabs-open -->

  ### Params
    * **id**: Unique identifier for the log object. (e.g `"dmwk7ra70oem3xa"`)

  #{ExDoppler.Doc.returns_block(success: "{:ok, %ExDoppler.ActivityLog{...}}", failure: "{:err, err}")}

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/activity_logs-retrieve){:target="_blank"}

  <!-- tabs-close -->
  """
  def get_activity_log(id) when is_bitstring(id) do
    path =
      @activity_logs_api_path
      |> Path.join("/log")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [log: id]) do
      {:ok, ActivityLog.build(body["log"])}
    end
  end

  @doc """
  Same as `get_activity_log/1` but won't wrap a successful response in `{:ok, response}`
  """
  def get_activity_log!(id) do
    with {:ok, activity_log} <- get_activity_log(id) do
      activity_log
    end
  end
end
