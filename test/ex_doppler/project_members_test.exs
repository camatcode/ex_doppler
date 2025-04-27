defmodule ExDoppler.ProjectMembersTest do
  use ExUnit.Case
  doctest ExDoppler.ProjectMembers

  alias ExDoppler.ProjectMembers
  alias ExDoppler.Projects

  test "Project Members" do
    {:ok, %{page: 1, projects: [project | _]}} = Projects.list_projects()
    assert {:ok, members} = ProjectMembers.list_project_members(project.slug, page: 1)
    refute Enum.empty?(members)

    members
    |> Enum.each(fn member ->
      assert member.access_all_environments != nil
      assert member.role.identifier
      assert member.slug
      assert member.type

      assert {:ok, member} ==
               ProjectMembers.get_project_member(project.slug, member.type, member.slug)
    end)

    assert {:ok, []} = ProjectMembers.list_project_members(project.slug, page: 200)
  end
end
