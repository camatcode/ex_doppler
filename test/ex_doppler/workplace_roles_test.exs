defmodule ExDoppler.WorkplaceRolesTest do
  use ExUnit.Case

  alias ExDoppler.WorkplaceRoles

  doctest ExDoppler.WorkplaceRoles

  test "list_workplace_roles/0, get_workplace_role/1" do
    assert {:ok, roles} = WorkplaceRoles.list_workplace_roles()
    refute Enum.empty?(roles)

    Enum.each(roles, fn role ->
      assert role.created_at
      assert role.identifier
      assert role.is_custom_role != nil
      assert role.is_inline_role != nil
      assert role.name
      assert role.permissions
      refute Enum.empty?(role.permissions)

      assert {:ok, role} == WorkplaceRoles.get_workplace_role(role.identifier)

      assert {:error, _} = WorkplaceRoles.get_workplace_role("does-not-exist")
    end)
  end
end
