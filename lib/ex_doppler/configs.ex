defmodule ExDoppler.Configs do
  @moduledoc """
  Module for interacting with `ExDoppler.Config`
  """

  alias ExDoppler.Config
  alias ExDoppler.Project
  alias ExDoppler.Util.Requester

  @configs_api_path "/v3/configs"

  @doc """
  Lists `ExDoppler.Config` using pagination.

  <!-- tabs-open -->

  ### Params
    * **project**: The `ExDoppler.Project` for which you want the configs (e.g `%Project{name: "example-project"}`)
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.Config` to return for this page (e.g `per_page: 50`). Default: `20`

  ### Returns

    **On Success**

    ```elixir
    {:ok, [%ExDoppler.Config{...} ...]}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/configs-list){:target="_blank"}

  <!-- tabs-close -->
  """
  def list_configs(%Project{name: project_name}, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@configs_api_path, qparams: opts) do
      configs =
        body["configs"]
        |> Enum.map(&Config.build/1)

      {:ok, configs}
    end
  end

  @doc """
  Same as `list_configs/2` but won't wrap a successful response in `{:ok, response}`
  """
  def list_configs!(%Project{} = project, opts \\ []) do
    with {:ok, configs} <- list_configs(project, opts) do
      configs
    end
  end

  @doc """
  Retrieves a `ExDoppler.Config`

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **config_name**: The config name to get (e.g `"dev_personal"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Config{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/configs-get){:target="_blank"}

  <!-- tabs-close -->
  """
  def get_config(project_name, config_name)
      when is_bitstring(project_name) and is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config")

    with {:ok, %{body: body}} <-
           Requester.get(path, qparams: [project: project_name, config: config_name]) do
      {:ok, Config.build(body["config"])}
    end
  end

  @doc """
  Same as `get_config/2` but won't wrap a successful response in `{:ok, response}`
  """
  def get_config!(project_name, config_name) do
    with {:ok, config} <- get_config(project_name, config_name) do
      config
    end
  end

  @doc """
  Creates a new `ExDoppler.Config`

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **environment_id**: The relevant environment id (e.g `"prd"`)
    * **config_name**: The config name to make (e.g `"prd_aws"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Config{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/configs-create){:target="_blank"}

  <!-- tabs-close -->
  """
  def create_config(project_name, environment_id, config_name)
      when is_bitstring(project_name) and
             is_bitstring(environment_id) and
             is_bitstring(config_name) do
    body = %{project: project_name, environment: environment_id, name: config_name}

    with {:ok, %{body: body}} <- Requester.post(@configs_api_path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  @doc """
  Same as `create_config/3` but won't wrap a successful response in `{:ok, response}`
  """
  def create_config!(project_name, environment_id, config_name) do
    with {:ok, config} <- create_config(project_name, environment_id, config_name) do
      config
    end
  end

  @doc """
  Renames a `ExDoppler.Config`

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **current_config_name**: The relevant environment id (e.g `"prd_aws"`)
    * **new_config_name**: The new config name (e.g `"prd_gcp"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Config{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/configs-update){:target="_blank"}

  <!-- tabs-close -->
  """
  def rename_config(project_name, current_config_name, new_config_name)
      when is_bitstring(project_name) and
             is_bitstring(current_config_name) and
             is_bitstring(new_config_name) do
    path =
      @configs_api_path
      |> Path.join("/config")

    body = %{project: project_name, config: current_config_name, name: new_config_name}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  @doc """
  Same as `rename_config/3` but won't wrap a successful response in `{:ok, response}`
  """
  def rename_config!(project_name, current_config_name, new_config_name) do
    with {:ok, config} <- rename_config(project_name, current_config_name, new_config_name) do
      config
    end
  end

  @doc """
  Clones a `ExDoppler.Config` to a new Config

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **source_config**: The config to clone (e.g `"prd_aws"`)
    * **new_config_name**: The config name to clone (e.g `"prd_aws2"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.ActivityLog{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/configs-clone){:target="_blank"}
  <!-- tabs-close -->
  """
  def clone_config(project_name, source_config, new_config_name)
      when is_bitstring(project_name) and
             is_bitstring(source_config) and
             is_bitstring(new_config_name) do
    path =
      @configs_api_path
      |> Path.join("/config/clone")

    body = %{project: project_name, config: source_config, name: new_config_name}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  @doc """
  Same as `clone_config/3` but won't wrap a successful response in `{:ok, response}`
  """
  def clone_config!(project_name, source_config, new_config_name) do
    with {:ok, config} <- clone_config(project_name, source_config, new_config_name) do
      config
    end
  end

  @doc """
  Locks a `ExDoppler.Config` (no modifications allowed)

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **config_name**: The config to lock (e.g `"prd_aws"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Config{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/configs-lock){:target="_blank"}
  <!-- tabs-close -->
  """
  def lock_config(project_name, config_name)
      when is_bitstring(project_name) and
             is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config/lock")

    body = %{project: project_name, config: config_name}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  @doc """
  Same as `lock_config/2` but won't wrap a successful response in `{:ok, response}`
  """
  def lock_config!(project_name, config_name) do
    with {:ok, config} <- lock_config(project_name, config_name) do
      config
    end
  end

  @doc """
  Unlocks a `ExDoppler.Config` (modifications allowed)

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **config_name**: The config to unlock (e.g `"prd_aws"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Config{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/configs-unlock){:target="_blank"}
  <!-- tabs-close -->
  """
  def unlock_config(project_name, config_name)
      when is_bitstring(project_name) and
             is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config/unlock")

    body = %{project: project_name, config: config_name}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  @doc """
  Same as `unlock_config/2` but won't wrap a successful response in `{:ok, response}`
  """
  def unlock_config!(project_name, config_name) do
    with {:ok, config} <- unlock_config(project_name, config_name) do
      config
    end
  end

  def set_config_inheritable(project_name, config_name, is_inheritable) do
    path =
      @configs_api_path
      |> Path.join("/config/inheritable")

    body = %{project: project_name, config: config_name, inheritable: is_inheritable}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  @doc """
  Same as `set_config_inheritable/3` but won't wrap a successful response in `{:ok, response}`
  """
  def set_config_inheritable!(project_name, config_name, is_inheritable) do
    with {:ok, config} <- set_config_inheritable(project_name, config_name, is_inheritable) do
      config
    end
  end

  @doc """
  Deletes a `ExDoppler.Config`

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **config_name**: The config to delete (e.g `"prd_aws"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, {:success, true}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/configs-delete){:target="_blank"}
  <!-- tabs-close -->
  """
  def delete_config(project_name, config_name)
      when is_bitstring(project_name) and
             is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config")

    opts = [qparams: [project: project_name, config: config_name]]

    with {:ok, %{body: _}} <- Requester.delete(path, opts) do
      {:ok, {:success, true}}
    end
  end

  @doc """
  Same as `delete_config/2` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_config!(project_name, config_name) do
    with {:ok, _} <- delete_config(project_name, config_name) do
      :ok
    end
  end

  def list_trusted_ips(project_name, config_name)
      when is_bitstring(project_name) and is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config/trusted_ips")

    with {:ok, %{body: body}} <-
           Requester.get(path, qparams: [project: project_name, config: config_name]) do
      {:ok, body["ips"]}
    end
  end
end
