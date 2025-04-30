defmodule ExDoppler.Projects do
  @moduledoc """
  Module for interacting with `ExDoppler.Project`

  <!-- tabs-open -->

  ### Help
    * See: `ExDoppler.Project`
    * See: [Doppler docs](https://docs.doppler.com/docs/create-project){:target="_blank"}
    * See: [Doppler API docs](https://docs.doppler.com/reference/projects-object){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """

  alias ExDoppler.Project
  alias ExDoppler.Util.Requester

  @projects_api_path "/v3/projects"

  @doc """
  Lists `ExDoppler.Project` using pagination

  <!-- tabs-open -->

  ### Params
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.Project` to return for this page (e.g `per_page: 50`). Default: `20`

  ### Returns

    **On Success**

    ```elixir
    {:ok, [%ExDoppler.Project{...} ...]}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/projects-list){:target="_blank"}
  <!-- tabs-close -->
  """
  def list_projects(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@projects_api_path, qparams: opts) do
      projects =
        body["projects"]
        |> Enum.map(&Project.build/1)

      {:ok, projects}
    end
  end

  @doc """
  Same as `list_projects/1` but won't wrap a successful response in `{:ok, response}`
  """
  def list_projects!(opts \\ []) do
    with {:ok, projects} <- list_projects(opts) do
      projects
    end
  end

  @doc """
  Retrieves a `ExDoppler.Project`, given an identifier

  <!-- tabs-open -->

  ### Params
   * `identifier` - identifier for project (e.g `"example-project"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Project{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/projects-get){:target="_blank"}
  <!-- tabs-close -->
  """
  def get_project(identifier) when is_bitstring(identifier) do
    path =
      @projects_api_path
      |> Path.join("/project")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [project: identifier]) do
      {:ok, Project.build(body["project"])}
    end
  end

  @doc """
  Same as `get_project/1` but won't wrap a successful response in `{:ok, response}`
  """
  def get_project!(identifier) do
    with {:ok, project} <- get_project(identifier) do
      project
    end
  end

  @doc """
  Creates a new `ExDoppler.Project`

  <!-- tabs-open -->

  ### Params
    * **project_name**: New Project Name (e.g `"example-project"`)
    * **description**: Optional description (e.g `"my awesome project"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Project{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/projects-create){:target="_blank"}
  <!-- tabs-close -->
  """
  def create_project(project_name, description \\ "")
      when is_bitstring(project_name) and is_bitstring(description) do
    body =
      %{name: project_name, description: description}
      |> Enum.filter(fn {_k, v} -> v end)
      |> Enum.into(%{})

    with {:ok, %{body: body}} <- Requester.post(@projects_api_path, json: body) do
      {:ok, Project.build(body["project"])}
    end
  end

  @doc """
  Same as `create_project/1` but won't wrap a successful response in `{:ok, response}`
  """
  def create_project!(project_name, description \\ "") do
    with {:ok, project} <- create_project(project_name, description) do
      project
    end
  end

  @doc """
  Updates an `ExDoppler.Project`

  <!-- tabs-open -->

  ### Params
    * **project**: The relevant project (e.g `%Project{name: "example-project" ...}`)
    * **opts**: Optional modifications
      * **name** - New name for this project
      * **description** - New description for this project

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Project{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/projects-update){:target="_blank"}
  <!-- tabs-close -->
  """
  def update_project(%Project{name: current_project_name}, opts \\ []) do
    with {:ok, project} <- get_project(current_project_name) do
      opts = Keyword.merge([name: project.name, description: project.description], opts)

      body =
        %{project: project.id, name: opts[:name], description: opts[:description]}
        |> Enum.filter(fn {_k, v} -> v end)
        |> Enum.into(%{})

      path =
        @projects_api_path
        |> Path.join("/project")

      with {:ok, %{body: body}} <- Requester.post(path, json: body) do
        {:ok, Project.build(body["project"])}
      end
    end
  end

  @doc """
  Same as `update_project/1` but won't wrap a successful response in `{:ok, response}`
  """
  def update_project!(%Project{} = project, opts \\ []) do
    with {:ok, project} <- update_project(project, opts) do
      project
    end
  end

  @doc """
  Deletes a `ExDoppler.Project`

  <!-- tabs-open -->

  ### Params
    * **project**: The relevant project (e.g `%Project{name: "example-project" ...}`)

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

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/projects-delete){:target="_blank"}

  <!-- tabs-close -->
  """
  def delete_project(%Project{name: project_name}) do
    path =
      @projects_api_path
      |> Path.join("/project")

    with {:ok, %{body: _}} <-
           Requester.delete(path, json: %{project: project_name}) do
      {:ok, {:success, true}}
    end
  end

  @doc """
  Same as `delete_project/1` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_project!(%Project{} = project) do
    with {:ok, project} <- delete_project(project) do
      project
    end
  end

  @doc """
  Lists project permissions across all roles

  <!-- tabs-open -->

  ### Returns

    **On Success**

    ```elixir
    {:ok, ["perm1"...]}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/project_roles-list_permissions){:target="_blank"}
  <!-- tabs-close -->
  """
  def list_project_permissions do
    path =
      @projects_api_path
      |> Path.join("/permissions")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, body["permissions"]}
    end
  end

  @doc """
  Same as `list_project_permissions/0` but won't wrap a successful response in `{:ok, response}`
  """
  def list_project_permissions! do
    with {:ok, permissions} <- list_project_permissions() do
      permissions
    end
  end
end
