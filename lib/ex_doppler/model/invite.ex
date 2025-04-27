defmodule ExDoppler.Invite do
  @moduledoc false

  import ExDoppler.Model
  defstruct [:slug, :email, :created_at, :workplace_role]

  def build(invite) do
    fields =
      invite
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Invite, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:workplace_role, val), do: struct(ExDoppler.WorkplaceRole, atomize_keys(val))
  defp serialize(_, val), do: val
end
