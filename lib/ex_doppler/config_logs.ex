# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ConfigLogs do
  @moduledoc """
  Module for interacting with `ExDoppler.ConfigLog`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("workplace-logs#config-logs", "config_logs-object")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Config
  alias ExDoppler.ConfigLog
  alias ExDoppler.Requester

  @config_logs_api_path "/v3/configs/config/logs"

  @doc """
  Lists `ExDoppler.ConfigLog` using pagination.

  <!-- tabs-open -->

  ### 🏷️ Params
    * **config**: The `ExDoppler.Config` for which you want the logs (e.g `%Config{project: "example-project", name: "dev"}`)
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.ConfigLog` to return for this page (e.g `per_page: 50`). Default: `20`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.ConfigLog{...}]}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.ConfigLogs
      iex> alias ExDoppler.Configs
      iex> alias ExDoppler.Projects
      iex> [project | _] = Projects.list_projects!()
      iex> [config | _] = Configs.list_configs!(project)
      iex> _config_logs = ConfigLogs.list_config_logs!(config, page: 1, per_page: 20)

  #{ExDoppler.Doc.resources("config_logs-list")}

  <!-- tabs-close -->
  """
  def list_config_logs(%Config{project: project_name, name: config_name}, opts \\ []) do
    qparams =
      Keyword.merge([page: 1, per_page: 20, project: project_name, config: config_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@config_logs_api_path, qparams: qparams) do
      logs = Enum.map(body["logs"], &ConfigLog.build/1)

      {:ok, logs}
    end
  end

  @doc """
  Same as `list_config_logs/2` but won't wrap a successful response in `{:ok, response}`
  """
  def list_config_logs!(%Config{} = config, opts \\ []) do
    with {:ok, config_logs} <- list_config_logs(config, opts) do
      config_logs
    end
  end

  @doc """
  Retrieves a `ExDoppler.ConfigLog`, given a config and log id

  <!-- tabs-open -->

  ### 🏷️ Params
    * **config**: The relevant `ExDoppler.Config` (e.g `%Config{project: "example-project", name: "dev"}`)
    * **log_id**: Unique identifier for the log object.

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.ConfigLog{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.ConfigLogs
      iex> alias ExDoppler.Configs
      iex> alias ExDoppler.Projects
      iex> [project | _] = Projects.list_projects!()
      iex> [config | _] = Configs.list_configs!(project)
      iex> _config_log = ConfigLogs.get_config_log(config, "Ul8KeqJzKK3n7OadwqX5RZW2")

  #{ExDoppler.Doc.resources("config_logs-get")}

  <!-- tabs-close -->
  """
  def get_config_log(%Config{project: project_name, name: config_name}, log_id) when is_bitstring(log_id) do
    path = Path.join(@config_logs_api_path, "/log")

    opts = [qparams: [project: project_name, config: config_name, log: log_id]]

    with {:ok, %{body: body}} <- Requester.get(path, opts) do
      {:ok, ConfigLog.build(body["log"])}
    end
  end

  @doc """
  Same as `get_config_log/2` but won't wrap a successful response in `{:ok, response}`
  """
  def get_config_log!(%Config{} = config, log_id) do
    with {:ok, config_log} <- get_config_log(config, log_id) do
      config_log
    end
  end

  @doc """
  Rolls back a `ExDoppler.ConfigLog`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **config_log**: The `ExDoppler.ConfigLog` to roll back (e.g `%ConfigLog{project: "example-project", config: "dev", id: "0000.."}`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.ConfigLog{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.ConfigLogs
      iex> alias ExDoppler.ConfigLog
      iex> _config_log = ConfigLogs.rollback_config_log!(%ConfigLog{project: "example-project", config: "dev", id: "Ul8KeqJzKK3n7OadwqX5RZW2" })

  #{ExDoppler.Doc.resources("config_logs-rollback")}

  <!-- tabs-close -->
  """
  def rollback_config_log(%ConfigLog{project: project_name, config: config_name, id: log_id}) do
    path = Path.join(@config_logs_api_path, "/log/rollback")

    opts = [qparams: [project: project_name, config: config_name, log: log_id]]

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, ConfigLog.build(body["log"])}
    end
  end

  @doc """
  Same as `rollback_config_log/1` but won't wrap a successful response in `{:ok, response}`
  """
  def rollback_config_log!(%ConfigLog{} = config_log) do
    with {:ok, log} <- rollback_config_log(config_log) do
      log
    end
  end
end
