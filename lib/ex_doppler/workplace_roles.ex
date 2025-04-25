defmodule ExDoppler.WorkplaceRoles do
  @moduledoc false

  alias ExDoppler.Util.Requester
  alias ExDoppler.Workplaces

  def workplace_roles_api_path, do: Path.join(Workplaces.workplace_api_path(), "/roles")

  def list_workplace_roles() do
    workplace_roles_api_path()
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

  def get_workplace_role(nil), do: nil

  def get_workplace_role(identifier) do
    workplace_roles_api_path()
    |> Path.join("/role/#{identifier}")
    |> Requester.get()
    |> case do
      {:ok, %{body: body}} ->
        {:ok, build_workplace_role(body["role"])}

      err ->
        err
    end
  end

  def list_permissions() do
    Path.join(Workplaces.workplace_api_path(), "/permissions")
    |> Requester.get()
    |> case do
         {:ok, %{body: body}} ->
           {:ok, body["permissions"]}

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
