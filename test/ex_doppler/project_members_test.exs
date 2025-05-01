defmodule ExDoppler.ProjectMembersTest do
  use ExUnit.Case
  doctest ExDoppler.ProjectMembers0

  alias ExDoppler.ProjectMembers
  alias ExDoppler.Projects

  test "list_project_members/2, get_project_member/3" do
    [project | _] = Projects.list_projects!()
    assert {:ok, members} = ProjectMembers.list_project_members(project, page: 1, per_page: 2)
    refute Enum.empty?(members)

    members
    |> Enum.each(fn member ->
      assert member.access_all_environments != nil
      assert member.role.identifier
      assert member.slug
      assert member.type

      assert {:ok, member} ==
               ProjectMembers.get_project_member(project, member.type, member.slug)
    end)

    assert {:ok, []} = ProjectMembers.list_project_members(project, page: 200)
  end
end
