defmodule ExDoppler.WorkplaceUsersTest do
  use ExUnit.Case
  doctest ExDoppler.WorkplaceUsers

  alias ExDoppler.WorkplaceUser
  alias ExDoppler.WorkplaceUsers

  test "list Workplace Users" do
    assert {:ok, %{page: 1, workplace_users: wp_users}} = WorkplaceUsers.list_workplace_users()
    refute Enum.empty?(wp_users)

    wp_users
    |> Enum.each(fn %WorkplaceUser{user: user} = wp_user ->
      assert wp_user.access
      assert wp_user.created_at
      assert wp_user.id
      assert user
      assert user.email
      assert user.name
      assert user.profile_image_url
      assert user.username

      assert {:ok, %{page: 1, workplace_users: by_email}} =
               WorkplaceUsers.list_workplace_users(email: user.email)

      refute Enum.empty?(by_email)
    end)

    assert {:ok, %{page: 2, workplace_users: []}} = WorkplaceUsers.list_workplace_users(page: 2)
  end
end
