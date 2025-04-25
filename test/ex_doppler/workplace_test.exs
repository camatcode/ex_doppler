defmodule ExDoppler.WorkplaceTest do
  use ExUnit.Case
  doctest ExDoppler.Workplaces

  alias ExDoppler.Workplaces

  test "retrieve Workplace" do
    assert {:ok, wp} = Workplaces.get_workplace()

    assert %Workplaces{} = wp
    assert wp.id
    assert wp.name
    assert wp.billing_email
    assert wp.security_email
  end
end
