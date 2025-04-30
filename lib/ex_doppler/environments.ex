defmodule ExDoppler.Environments do
  @moduledoc """
  Module for interacting with `ExDoppler.Environment`

  <!-- tabs-open -->

  ### Resources
    * See: `ExDoppler.Environment`
    * See: [Doppler docs](https://docs.doppler.com/docs/create-project#environments){:target="_blank"}
    * See: [Doppler API docs](https://docs.doppler.com/reference/environments-object){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """

  alias ExDoppler.Environment
  alias ExDoppler.Project
  alias ExDoppler.Util.Requester

  @environments_api_path "/v3/environments"

  @doc """
  Lists `ExDoppler.Environment` using pagination.

  <!-- tabs-open -->

  ### Params
    * **project**: The `ExDoppler.Project` for which you want the environments (e.g `%Project{name: "example-project"}`)
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.Environment` to return for this page (e.g `per_page: 50`). Default: `20`

  ### Returns

    **On Success**

    ```elixir
    {:ok, [%ExDoppler.Environment{...} ...]}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/environments-list){:target="_blank"}

  <!-- tabs-close -->
  """
  def list_environments(%Project{name: project_name}, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@environments_api_path, qparams: opts) do
      environments =
        body["environments"]
        |> Enum.map(&Environment.build/1)

      {:ok, environments}
    end
  end

  @doc """
  Same as `list_environments/2` but won't wrap a successful response in `{:ok, response}`
  """
  def list_environments!(%Project{} = project, opts \\ []) do
    with {:ok, environments} <- list_environments(project, opts) do
      environments
    end
  end

  @doc """
  Retrieves a `ExDoppler.Environment`

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **config_name**: The environment to get (e.g `"dev"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Environment{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/environments-get){:target="_blank"}

  <!-- tabs-close -->
  """
  def get_environment(%Project{name: project_name}, environment_slug)
      when is_bitstring(environment_slug) do
    path =
      @environments_api_path
      |> Path.join("/environment")

    opts = [qparams: [project: project_name, environment: environment_slug]]

    with {:ok, %{body: body}} <- Requester.get(path, opts) do
      {:ok, Environment.build(body["environment"])}
    end
  end

  @doc """
  Same as `get_environment/2` but won't wrap a successful response in `{:ok, response}`
  """
  def get_environment!(%Project{} = project, environment_slug) do
    with {:ok, environment} <- get_environment(project, environment_slug) do
      environment
    end
  end

  @doc """
  Creates a new `ExDoppler.Environment`

  <!-- tabs-open -->

  ### Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **env_name**: A new environment's name (e.g `"prd"`)
    * **env_slug**: A new environment's slug (e.g `"prd"`)
    * **enable_personal_config**: Optional setting if this environment has personal configs (default: `false`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Environment{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/environments-create){:target="_blank"}

  <!-- tabs-close -->
  """
  def create_environment(
        %Project{name: project_name},
        env_name,
        env_slug,
        enable_personal_config \\ false
      )
      when is_bitstring(env_name) and is_bitstring(env_slug) and
             is_boolean(enable_personal_config) do
    body = %{name: env_name, slug: env_slug, personal_configs: enable_personal_config}
    opts = [qparams: [project: project_name], json: body]

    with {:ok, %{body: body}} <- Requester.post(@environments_api_path, opts) do
      {:ok, Environment.build(body["environment"])}
    end
  end

  @doc """
  Same as `create_environment/4` but won't wrap a successful response in `{:ok, response}`
  """
  def create_environment!(
        %Project{} = project,
        env_name,
        env_slug,
        enable_personal_config \\ false
      ) do
    with {:ok, environment} <-
           create_environment(project, env_name, env_slug, enable_personal_config) do
      environment
    end
  end

  @doc """
  Updates an `ExDoppler.Environment`, given a project name, a env slug and options detailing modifications

  <!-- tabs-open -->

  ### Params
    * **environment**: The relevant environment (e.g `%Environment{project: "example-project", slug: "dev" ...}`)
    * **opts**: Optional modifications
      * **name** - New name for this environment
      * **slug** - New slug for this environment
      * **personal_configs** - If set true, will enable personal configs

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Environment{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/environments-rename){:target="_blank"}

  <!-- tabs-close -->
  """
  def update_environment(%Environment{project: project_name, slug: env_slug}, opts \\ []) do
    with {:ok, environment} <- get_environment(%Project{name: project_name}, env_slug) do
      path =
        @environments_api_path
        |> Path.join("/environment")

      opts =
        Keyword.merge(
          [name: environment.name, slug: environment.slug, personal_configs: nil],
          opts
        )

      body =
        %{name: opts[:name], slug: opts[:slug], personal_configs: opts[:personal_configs]}
        |> Enum.filter(fn {_k, v} -> v end)
        |> Enum.into(%{})

      qparams = [project: project_name, environment: env_slug]

      with {:ok, %{body: body}} <- Requester.put(path, qparams: qparams, json: body) do
        {:ok, Environment.build(body["environment"])}
      end
    end
  end

  @doc """
  Same as `update_environment/2` but won't wrap a successful response in `{:ok, response}`
  """
  def update_environment!(%Environment{} = environment, opts \\ []) do
    with {:ok, environment} <- update_environment(environment, opts) do
      environment
    end
  end

  @doc """
  Deletes a `ExDoppler.Environment`

  <!-- tabs-open -->

  ### Params
    * **environment**: The relevant environment (e.g `%Environment{project: "example-project", slug: "dev" ...}`)

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

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/environments-delete){:target="_blank"}

  <!-- tabs-close -->
  """
  def delete_environment(%Environment{project: project_name, slug: env_slug}) do
    opts = [qparams: [project: project_name, environment: env_slug]]

    path =
      @environments_api_path
      |> Path.join("/environment")

    with {:ok, %{body: _}} <- Requester.delete(path, opts) do
      {:ok, {:success, true}}
    end
  end

  @doc """
  Same as `delete_environment/1` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_environment!(%Environment{} = environment) do
    with {:ok, _} <- delete_environment(environment) do
      :ok
    end
  end
end
