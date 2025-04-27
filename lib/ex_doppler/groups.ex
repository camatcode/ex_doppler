defmodule ExDoppler.Groups do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @groups_api_path "v3/workplace/groups"

  def list_groups(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@groups_api_path, qparams: opts) do
      groups =
        body["groups"]
        |> Enum.map(&build_group/1)
    end
  end

  defp build_group(group) do
    fields =
      group
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Group, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:default_project_role, val) do
    val =
      val
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.DefaultWorkplaceRole, val)
  end

  defp serialize(_, val), do: val
end
