defmodule ExDoppler.InvitesTest do
  use ExUnit.Case

  alias ExDoppler.Invites

  doctest ExDoppler.Invites

  test "list_invites/1" do
    assert {:ok, invites} = Invites.list_invites()

    Enum.each(invites, fn invite ->
      assert invite.slug
      assert invite.email
      assert invite.created_at
      assert invite.workplace_role
    end)
  end
end
