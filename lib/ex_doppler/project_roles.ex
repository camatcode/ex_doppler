defmodule ExDoppler.ProjectRoles do
  @moduledoc false

  alias ExDoppler.ProjectRole
  alias ExDoppler.Util.Requester

  @project_roles_api_path "/v3/projects/roles"

  def list_project_roles() do
    with {:ok, %{body: body}} <- Requester.get(@project_roles_api_path) do
      roles =
        body["roles"]
        |> Enum.map(&ProjectRole.build_project_role/1)

      {:ok, roles}
    end
  end

  def get_project_role(identifier) when is_bitstring(identifier) do
    path =
      @project_roles_api_path
      |> Path.join("/role/#{identifier}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, ProjectRole.build_project_role(body["role"])}
    end
  end
end
