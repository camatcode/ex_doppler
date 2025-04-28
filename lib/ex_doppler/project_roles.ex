defmodule ExDoppler.ProjectRoles do
  @moduledoc false

  alias ExDoppler.ProjectRole
  alias ExDoppler.Util.Requester

  @project_roles_api_path "/v3/projects/roles"

  def list_project_roles do
    with {:ok, %{body: body}} <- Requester.get(@project_roles_api_path) do
      roles =
        body["roles"]
        |> Enum.map(&ProjectRole.build/1)

      {:ok, roles}
    end
  end

  def list_project_roles! do
    with {:ok, project_roles} <- list_project_roles() do
      project_roles
    end
  end

  def get_project_role(identifier) when is_bitstring(identifier) do
    path =
      @project_roles_api_path
      |> Path.join("/role/#{identifier}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, ProjectRole.build(body["role"])}
    end
  end

  def get_project_role!(identifier) do
    with {:ok, project_role} <- get_project_role(identifier) do
      project_role
    end
  end

  def create_project_role(name, permissions)
      when is_bitstring(name) and is_list(permissions) do
    opts = [json: %{name: name, permissions: permissions}]

    with {:ok, %{body: body}} <- Requester.post(@project_roles_api_path, opts) do
      {:ok, ProjectRole.build(body["role"])}
    end
  end

  def create_project_role!(name, permissions) do
    with {:ok, role} <- create_project_role(name, permissions) do
      role
    end
  end
end
