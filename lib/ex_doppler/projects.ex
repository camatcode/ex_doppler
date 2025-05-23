# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Projects do
  @moduledoc """
  Module for interacting with `ExDoppler.Project`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("create-project", "projects-object")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Project
  alias ExDoppler.Requester

  @projects_api_path "/v3/projects"

  @doc """
  Lists `ExDoppler.Project` using pagination

  <!-- tabs-open -->

  ### 🏷️ Params
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.Project` to return for this page (e.g `per_page: 50`). Default: `20`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.Project{...} ...]}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Projects
      iex> {:ok, _projects} = Projects.list_projects(page: 1, per_page: 20)

  #{ExDoppler.Doc.resources("projects-list")}

  <!-- tabs-close -->
  """
  def list_projects(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@projects_api_path, qparams: opts) do
      projects = Enum.map(body["projects"], &Project.build/1)

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

  ### 🏷️ Params
   * `identifier` - identifier for project (e.g `"example-project"`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Project{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Projects
      iex> {:ok, _project} = Projects.get_project("example-project")

  #{ExDoppler.Doc.resources("projects-get")}

  <!-- tabs-close -->
  """
  def get_project(identifier) when is_bitstring(identifier) do
    path = Path.join(@projects_api_path, "/project")

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

  ### 🏷️ Params
    * **project_name**: New Project Name (e.g `"example-project"`)
    * **description**: Optional description (e.g `"my awesome project"`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Project{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Projects
      iex> alias ExDoppler.Project
      iex> _ = Projects.delete_project!(%Project{name: "example-doc-project"})
      iex> {:ok, project} = Projects.create_project("example-doc-project")
      iex> :ok = Projects.delete_project!(project)

  #{ExDoppler.Doc.resources("projects-create")}

  <!-- tabs-close -->
  """
  def create_project(project_name, description \\ "") when is_bitstring(project_name) and is_bitstring(description) do
    body =
      %{name: project_name, description: description}
      |> Enum.filter(fn {_k, v} -> v end)
      |> Map.new()

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

  ### 🏷️ Params
    * **project**: The relevant project (e.g `%Project{name: "example-project" ...}`)
    * **opts**: Optional modifications
      * **name** - New name for this project
      * **description** - New description for this project

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Project{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Projects
      iex> alias ExDoppler.Project
      iex> _ = Projects.delete_project!(%Project{name: "example-doc-project"})
      iex> project = Projects.create_project!("example-doc-project")
      iex> {:ok, project} = Projects.update_project(project, description: "new description")
      iex> :ok = Projects.delete_project!(project)

  #{ExDoppler.Doc.resources("projects-update")}

  <!-- tabs-close -->
  """
  def update_project(%Project{name: current_project_name}, opts \\ []) do
    with {:ok, project} <- get_project(current_project_name) do
      opts = Keyword.merge([name: project.name, description: project.description], opts)

      body =
        %{project: project.id, name: opts[:name], description: opts[:description]}
        |> Enum.filter(fn {_k, v} -> v end)
        |> Map.new()

      path = Path.join(@projects_api_path, "/project")

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

  ### 🏷️ Params
    * **project**: The relevant project (e.g `%Project{name: "example-project" ...}`)

  #{ExDoppler.Doc.returns(success: "{:ok, {:success, true}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Projects
      iex> alias ExDoppler.Project
      iex> _ = Projects.delete_project!(%Project{name: "example-doc-project"})
      iex> project = Projects.create_project!("example-doc-project")
      iex> {:ok, {:success, true}} = Projects.delete_project(project)

  #{ExDoppler.Doc.resources("projects-delete")}

  <!-- tabs-close -->
  """
  def delete_project(%Project{name: project_name}) do
    path = Path.join(@projects_api_path, "/project")

    with {:ok, %{body: _}} <-
           Requester.delete(path, json: %{project: project_name}) do
      {:ok, {:success, true}}
    end
  end

  @doc """
  Same as `delete_project/1` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_project!(%Project{} = project) do
    with {:ok, _} <- delete_project(project) do
      :ok
    end
  end

  @doc """
  Lists project permissions across all roles

  <!-- tabs-open -->

  #{ExDoppler.Doc.returns(success: "{:ok, [\"perm1\" ...]}", failure: "{:error, err}")}

  #{ExDoppler.Doc.resources("project_roles-list_permissions")}

  <!-- tabs-close -->
  """
  def list_project_permissions do
    path = Path.join(@projects_api_path, "/permissions")

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
