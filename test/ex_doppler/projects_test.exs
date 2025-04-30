defmodule ExDoppler.ProjectsTest do
  use ExUnit.Case
  doctest ExDoppler.Projects

  alias ExDoppler.Project
  alias ExDoppler.Projects

  test "Projects" do
    name = "one-two-three"
    description = "An example project"
    Projects.delete_project(%Project{name: name})
    assert {:ok, new_project} = Projects.create_project(name, description)

    assert new_project.created_at
    assert new_project.description == description
    assert new_project.id == name
    assert new_project.name == name
    assert new_project.slug == name

    new_description = "A new description"

    assert {:ok, new_project} =
             Projects.update_project(new_project, description: new_description)

    assert new_project.description == new_description

    {:ok, projects} = Projects.list_projects()
    refute Enum.empty?(projects)

    projects
    |> Enum.each(fn project ->
      assert project.created_at
      assert project.description
      assert project.id
      assert project.name
      assert project.slug

      assert {:ok, project} == Projects.get_project(project.id)
    end)

    assert {:ok, [project]} = Projects.list_projects(per_page: 1)
    assert project.id

    {:ok, permissions} = Projects.list_project_permissions()
    refute Enum.empty?(permissions)

    assert {:ok, _} = Projects.delete_project(new_project)
  end
end
