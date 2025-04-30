# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ProjectRoles do
  @moduledoc """
  Module for interacting with `ExDoppler.ProjectRole`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("project-permissions", "project_roles-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.ProjectRole
  alias ExDoppler.Util.Requester

  @project_roles_api_path "/v3/projects/roles"

  @doc """
  Lists `ExDoppler.ProjectRole`

  <!-- tabs-open -->
  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.ProjectRole{...} ...]}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("project_roles-list")}

  <!-- tabs-close -->
  """
  def list_project_roles do
    with {:ok, %{body: body}} <- Requester.get(@project_roles_api_path) do
      roles =
        body["roles"]
        |> Enum.map(&ProjectRole.build/1)

      {:ok, roles}
    end
  end

  @doc """
  Same as `list_project_roles/1` but won't wrap a successful response in `{:ok, response}`
  """
  def list_project_roles! do
    with {:ok, project_roles} <- list_project_roles() do
      project_roles
    end
  end

  @doc """
  Retrieves a `ExDoppler.ProjectRole`

  <!-- tabs-open -->

  ### 🏷️ Params
   * **identifier** - identifier for role -  e.g `"collaborator"` or `"admin"` or `"viewer"` or `"no_access"`

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.ProjectRole{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("project_roles-get")}

  <!-- tabs-close -->
  """
  def get_project_role(identifier) when is_bitstring(identifier) do
    path =
      @project_roles_api_path
      |> Path.join("/role/#{identifier}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, ProjectRole.build(body["role"])}
    end
  end

  @doc """
  Same as `get_project_role/1` but won't wrap a successful response in `{:ok, response}`
  """
  def get_project_role!(identifier) do
    with {:ok, project_role} <- get_project_role(identifier) do
      project_role
    end
  end

  @doc """
  Creates a new `ExDoppler.ProjectRole`, given a name and list of permissions

  <!-- tabs-open -->

  ### 🏷️ Params
    * **name**: Role name (e.g `"viewer_but_different"`)
    * **permissions**: List of permissions given to the role. See [Doppler Docs](https://docs.doppler.com/reference/project_roles-create){:target="_blank"}

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.ProjectRole{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("project_roles-create")}

  <!-- tabs-close -->
  """
  def create_project_role(name, permissions)
      when is_bitstring(name) and is_list(permissions) do
    opts = [json: %{name: name, permissions: permissions}]

    with {:ok, %{body: body}} <- Requester.post(@project_roles_api_path, opts) do
      {:ok, ProjectRole.build(body["role"])}
    end
  end

  @doc """
  Same as `create_project_role/1` but won't wrap a successful response in `{:ok, response}`
  """
  def create_project_role!(name, permissions) do
    with {:ok, role} <- create_project_role(name, permissions) do
      role
    end
  end
end
