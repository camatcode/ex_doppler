defmodule ExDoppler.ProjectMember do
  @moduledoc false
  import ExDoppler.Model

  defstruct [:access_all_environments, :environments, :role, :slug, :type]

  def build(member) do
    fields =
      member
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ProjectMember, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:role, val), do: struct(ExDoppler.ProjectMemberRole, atomize_keys(val))
  defp serialize(_, val), do: val
end

defmodule ExDoppler.ProjectMemberRole do
  @moduledoc false
  defstruct [:identifier]
end
