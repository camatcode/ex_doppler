defmodule ExDoppler.ProjectRoles do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def project_roles_api_path, do: "/v3/projects/roles"

  def list_project_roles() do
    project_roles_api_path()
    |> Requester.get()
    |> case do
      {:ok, %{body: body}} ->
        roles =
          body["roles"]
          |> Enum.map(&build_project_role/1)

        {:ok, roles}

      err ->
        err
    end
  end

  def get_project_role(identifier) do
    project_roles_api_path()
    |> Path.join("/role/#{identifier}")
    |> Requester.get()
    |> case do
      {:ok, %{body: body}} ->
        {:ok, build_project_role(body["role"])}

      err ->
        err
    end
  end

  def list_project_permissions() do
    ExDoppler.Projects.projects_api_path()
    |> Path.join("/permissions")
    |> Requester.get()
    |> case do
      {:ok, %{body: body}} ->
        {:ok, body["permissions"]}

      err ->
        err
    end
  end

  def build_project_role(role) do
    fields =
      role
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.ProjectRole, fields)
  end
end
