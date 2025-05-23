# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Environments do
  @moduledoc """
  Module for interacting with `ExDoppler.Environment`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("create-project#environments", "environments-object")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Environment
  alias ExDoppler.Project
  alias ExDoppler.Requester

  @environments_api_path "/v3/environments"

  @doc """
  Lists `ExDoppler.Environment` using pagination.

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project**: The `ExDoppler.Project` for which you want the environments (e.g `%Project{name: "example-project"}`)
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.Environment` to return for this page (e.g `per_page: 50`). Default: `20`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.Environment{...}]}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Environments
      iex> alias ExDoppler.Projects
      iex> [project | _] = Projects.list_projects!()
      iex> {:ok, _envs} = Environments.list_environments(project, page: 1, per_page: 20)

  #{ExDoppler.Doc.resources("environments-list")}

  <!-- tabs-close -->
  """
  def list_environments(%Project{name: project_name}, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@environments_api_path, qparams: opts) do
      environments = Enum.map(body["environments"], &Environment.build/1)

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

  ### 🏷️ Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **config_name**: The environment to get (e.g `"dev"`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Environment{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Environments
      iex> alias ExDoppler.Projects
      iex> [project | _] = Projects.list_projects!()
      iex> {:ok, _env} = Environments.get_environment(project, "dev")

  #{ExDoppler.Doc.resources("environments-get")}

  <!-- tabs-close -->
  """
  def get_environment(%Project{name: project_name}, environment_slug) when is_bitstring(environment_slug) do
    path = Path.join(@environments_api_path, "/environment")

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

  ### 🏷️ Params
    * **project_name**: The relevant project name (e.g `"example-project"`)
    * **env_name**: A new environment's name (e.g `"prd"`)
    * **env_slug**: A new environment's slug (e.g `"prd"`)
    * **enable_personal_config**: Optional setting if this environment has personal configs (default: `false`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Environment{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Environments
      iex> alias ExDoppler.Environment
      iex> alias ExDoppler.Projects
      iex> [project | _] = Projects.list_projects!()
      iex> _ = Environments.delete_environment(%Environment{project: project.name, slug: "envdoc"})
      iex> {:ok, env} = Environments.create_environment(project, "envdoc", "envdoc")
      iex> :ok = Environments.delete_environment!(env)

  #{ExDoppler.Doc.resources("environments-create")}

  <!-- tabs-close -->
  """
  def create_environment(%Project{name: project_name}, env_name, env_slug, enable_personal_config \\ false)
      when is_bitstring(env_name) and is_bitstring(env_slug) and is_boolean(enable_personal_config) do
    body = %{name: env_name, slug: env_slug, personal_configs: enable_personal_config}
    opts = [qparams: [project: project_name], json: body]

    with {:ok, %{body: body}} <- Requester.post(@environments_api_path, opts) do
      {:ok, Environment.build(body["environment"])}
    end
  end

  @doc """
  Same as `create_environment/4` but won't wrap a successful response in `{:ok, response}`
  """
  def create_environment!(%Project{} = project, env_name, env_slug, enable_personal_config \\ false) do
    with {:ok, environment} <-
           create_environment(project, env_name, env_slug, enable_personal_config) do
      environment
    end
  end

  @doc """
  Updates an `ExDoppler.Environment`, given a project name, a env slug and options detailing modifications

  <!-- tabs-open -->

  ### 🏷️ Params
    * **environment**: The relevant environment (e.g `%Environment{project: "example-project", slug: "dev" ...}`)
    * **opts**: Optional modifications
      * **name** - New name for this environment
      * **slug** - New slug for this environment
      * **personal_configs** - If set true, will enable personal configs

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Environment{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Environments
      iex> alias ExDoppler.Environment
      iex> alias ExDoppler.Projects
      iex> [project | _] = Projects.list_projects!()
      iex> _ = Environments.delete_environment(%Environment{project: project.name, slug: "envdoc"})
      iex> _ = Environments.delete_environment(%Environment{project: project.name, slug: "envdoc2"})
      iex> {:ok, env} = Environments.create_environment(project, "envdoc", "envdoc")
      iex> {:ok, updated} = Environments.update_environment(env, name: "envdoc2", personal_configs: true)
      iex> :ok = Environments.delete_environment!(updated)

  #{ExDoppler.Doc.resources("environments-rename")}

  <!-- tabs-close -->
  """
  def update_environment(%Environment{project: project_name, slug: env_slug}, opts \\ []) do
    with {:ok, environment} <- get_environment(%Project{name: project_name}, env_slug) do
      path = Path.join(@environments_api_path, "/environment")

      opts =
        Keyword.merge(
          [name: environment.name, slug: environment.slug, personal_configs: nil],
          opts
        )

      body =
        %{name: opts[:name], slug: opts[:slug], personal_configs: opts[:personal_configs]}
        |> Enum.filter(fn {_k, v} -> v end)
        |> Map.new()

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

  ### 🏷️ Params
    * **environment**: The relevant environment (e.g `%Environment{project: "example-project", slug: "dev" ...}`)

  #{ExDoppler.Doc.returns(success: "{:ok, {:success, true}}", failure: "{:error, err}")}
  ### 💻 Examples

      iex> alias ExDoppler.Environments
      iex> alias ExDoppler.Environment
      iex> alias ExDoppler.Projects
      iex> [project | _] = Projects.list_projects!()
      iex> _ = Environments.delete_environment(%Environment{project: project.name, slug: "envdoc"})
      iex> {:ok, env} = Environments.create_environment(project, "envdoc", "envdoc")
      iex> {:ok, {:success, true}} = Environments.delete_environment(env)

  #{ExDoppler.Doc.resources("environments-delete")}

  <!-- tabs-close -->
  """
  def delete_environment(%Environment{project: project_name, slug: env_slug}) do
    opts = [qparams: [project: project_name, environment: env_slug]]

    path = Path.join(@environments_api_path, "/environment")

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
