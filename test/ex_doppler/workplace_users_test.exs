defmodule ExDoppler.WorkplaceUsersTest do
  use ExUnit.Case

  alias ExDoppler.WorkplaceUser
  alias ExDoppler.WorkplaceUsers

  doctest ExDoppler.WorkplaceUsers

  test "list_workplace_users/1, get_workplace_user/1, update_workplace_user/2" do
    assert {:ok, wp_users} = WorkplaceUsers.list_workplace_users()
    refute Enum.empty?(wp_users)

    Enum.each(wp_users, fn %WorkplaceUser{user: user} = wp_user ->
      assert wp_user.access
      assert wp_user.created_at
      assert wp_user.id
      assert user
      assert user.email
      assert user.name
      assert user.profile_image_url
      assert user.username

      assert {:ok, by_email} =
               WorkplaceUsers.list_workplace_users(email: user.email)

      refute Enum.empty?(by_email)

      assert {:ok, wp_user} == WorkplaceUsers.get_workplace_user(wp_user.id)

      assert {:ok, wp_user} == WorkplaceUsers.update_workplace_user(wp_user, :owner)
    end)

    assert {:ok, []} = WorkplaceUsers.list_workplace_users(page: 2)

    assert {:error, _} = WorkplaceUsers.get_workplace_user("does-not-exist")
  end
end
