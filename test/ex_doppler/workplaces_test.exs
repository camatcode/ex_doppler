defmodule ExDoppler.WorkplacesTest do
  use ExUnit.Case
  doctest ExDoppler.Workplaces

  alias ExDoppler.Workplace
  alias ExDoppler.Workplaces

  test "retrieve Workplace" do
    assert {:ok, wp} = Workplaces.get_workplace()

    assert %Workplace{} = wp
    assert wp.id
    assert wp.name
    assert wp.billing_email
    assert wp.security_email

    assert {:ok, permissions} = Workplaces.list_permissions()
    refute Enum.empty?(permissions)
  end
end
