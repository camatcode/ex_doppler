defmodule ExDoppler.WorkplaceRoles do
  @moduledoc false

  alias ExDoppler.Util.Requester
  alias ExDoppler.WorkplaceRole

  @workplace_roles_api_path "/v3/workplace/roles"

  def list_workplace_roles do
    with {:ok, %{body: body}} <- Requester.get(@workplace_roles_api_path) do
      roles =
        body["roles"]
        |> Enum.map(&WorkplaceRole.build/1)

      {:ok, roles}
    end
  end

  def get_workplace_role(identifier) when is_bitstring(identifier) do
    path =
      @workplace_roles_api_path
      |> Path.join("/role/#{identifier}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, WorkplaceRole.build(body["role"])}
    end
  end
end
