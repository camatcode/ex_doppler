defmodule ExDoppler.ProjectMember do
  @moduledoc false
  import ExDoppler.Model

  alias ExDoppler.ProjectMemberRole

  defstruct [:access_all_environments, :environments, :role, :slug, :type]

  def build(member) do
    fields =
      member
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ProjectMember, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:role, val), do: ProjectMemberRole.build(val)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.ProjectMemberRole do
  @moduledoc false
  import ExDoppler.Model

  defstruct [:identifier]

  def build(role), do: struct(ExDoppler.ProjectMemberRole, prepare_keys(role))
end
