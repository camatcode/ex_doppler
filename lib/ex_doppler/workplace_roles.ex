defmodule ExDoppler.WorkplaceRoles do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @workplace_roles_api_path "/v3/workplace/roles"

  def list_workplace_roles() do
    with {:ok, %{body: body}} <- Requester.get(@workplace_roles_api_path) do
      roles =
        body["roles"]
        |> Enum.map(&build_workplace_role/1)

      {:ok, roles}
    end
  end

  def get_workplace_role(identifier) when is_bitstring(identifier) do
    path =
      @workplace_roles_api_path
      |> Path.join("/role/#{identifier}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, build_workplace_role(body["role"])}
    end
  end

  defp build_workplace_role(wp_role) do
    fields =
      wp_role
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.WorkplaceRole, fields)
  end
end
