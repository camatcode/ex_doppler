defmodule ExDoppler.WorkplaceRoles do
  @moduledoc false

  alias ExDoppler.Util.Requester
  alias ExDoppler.Workplaces

  def workplace_users_api_path, do: Path.join(Workplaces.workplace_api_path(), "/roles")

  def list_workplace_roles() do
    workplace_users_api_path()
    |> Requester.get()
    |> case do
      {:ok, %{body: body}} ->
        roles =
          body["roles"]
          |> Enum.map(&build_workplace_role/1)

        {:ok, roles}

      err ->
        err
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
