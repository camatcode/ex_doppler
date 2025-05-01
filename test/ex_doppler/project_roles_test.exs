defmodule ExDoppler.ProjectRolesTest do
  use ExUnit.Case
  doctest ExDoppler.ProjectRoles

  alias ExDoppler.ProjectRoles

  test "list_project_roles/0, get_project_role/1" do
    {:ok, roles} = ProjectRoles.list_project_roles()
    refute Enum.empty?(roles)

    roles
    |> Enum.each(fn role ->
      assert role.created_at
      assert role.identifier
      assert role.is_custom_role != nil
      assert role.name
      assert role.permissions

      assert {:ok, role} == ProjectRoles.get_project_role(role.identifier)
    end)
  end
end
