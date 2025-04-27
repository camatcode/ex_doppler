defmodule ExDoppler.InvitesTest do
  use ExUnit.Case
  doctest ExDoppler.Invites

  alias ExDoppler.Invites

  test "Integrations" do
    assert {:ok, invites} = Invites.list_invites()

    invites
    |> Enum.each(fn invite ->
      assert invite.slug
      assert invite.email
      assert invite.created_at
      assert invite.workplace_role
    end)
  end
end
