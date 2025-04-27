defmodule ExDoppler.InvitesTest do
  use ExUnit.Case
  doctest ExDoppler.Invites

  alias ExDoppler.Invites

  test "Integrations" do
    assert {:ok, _invites} = Invites.list_invites() |> IO.inspect()
  end
end
