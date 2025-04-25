defmodule ExDoppler.WorkplaceRolesTest do
  use ExUnit.Case
  doctest ExDoppler.WorkplaceRoles

  alias ExDoppler.WorkplaceRoles

  test "list Workplace Roles" do
    assert {:ok, roles} = WorkplaceRoles.list_workplace_roles()
    refute Enum.empty?(roles)
    roles
    |> Enum.each(fn role ->
        assert role.created_at
        assert role.identifier
        assert role.is_custom_role != nil
        assert role.is_inline_role != nil
        assert role.name
        assert role.permissions
        refute Enum.empty?(role.permissions)
    end)
  end
end
