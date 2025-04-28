defmodule ExDoppler.ServiceAccount do
  @moduledoc false
  import ExDoppler.Model

  alias ExDoppler.WorkplaceRole

  defstruct [:name, :slug, :created_at, :workplace_role]

  def build(account) do
    fields =
      account
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ServiceAccount, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:workplace_role, val), do: WorkplaceRole.build(val)
  defp serialize(_, val), do: val
end
