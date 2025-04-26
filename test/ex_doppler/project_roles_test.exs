defmodule ExDoppler.ProjectRolesTest do
  use ExUnit.Case
  doctest ExDoppler.ProjectRoles

  alias ExDoppler.ProjectRoles

  test "Project Roles" do
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
