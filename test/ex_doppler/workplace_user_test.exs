defmodule ExDoppler.WorkplaceTest do
  use ExUnit.Case
  doctest ExDoppler.WorkplaceUsers

  alias ExDoppler.WorkplaceUsers

  test "list Workplace Users" do
    assert {:ok, %{page: 1, workplace_users: wp_users}} = WorkplaceUsers.list_workplace_users()
    refute Enum.empty?(wp_users)

    wp_users
    |> Enum.each(fn %ExDoppler.WorkplaceUser{user: user} = wp_user ->
      assert wp_user.access
      assert wp_user.created_at
      assert wp_user.id
      assert user
      assert user.email
      assert user.name
      assert user.profile_image_url
      assert user.username
    end)
  end

  test "list next page of Workplace Users" do
    assert {:ok, %{page: 2, workplace_users: []}} = WorkplaceUsers.list_workplace_users(page: 2)
  end

  test "filter by email" do

  end
end
