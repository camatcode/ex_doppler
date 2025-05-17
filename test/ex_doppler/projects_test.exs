defmodule ExDoppler.ProjectsTest do
  use ExUnit.Case

  alias ExDoppler.Project
  alias ExDoppler.Projects

  doctest ExDoppler.Projects

  test "list_projects/1, get_project/1" do
    {:ok, projects} = Projects.list_projects()
    refute Enum.empty?(projects)

    Enum.each(projects, fn project ->
      assert project.created_at
      assert project.description
      assert project.id
      assert project.name
      assert project.slug

      assert {:ok, project} == Projects.get_project(project.id)
    end)

    assert {:ok, [project]} = Projects.list_projects(per_page: 1)
    assert project.id
  end

  test "delete_project/1, create_project/2, update_project/2, list_project_permissions/0" do
    name = String.replace(Faker.Internet.domain_word(), "_", "-")
    description = String.replace(Faker.Internet.domain_word(), "_", "-")
    Projects.delete_project(%Project{name: name})
    assert {:ok, new_project} = Projects.create_project(name, description)

    assert new_project.created_at
    assert new_project.description == description
    assert new_project.id == name
    assert new_project.name == name
    assert new_project.slug == name

    new_description = String.replace(Faker.Internet.domain_word(), "_", "-")

    assert {:ok, new_project} =
             Projects.update_project(new_project, description: new_description)

    assert new_project.description == new_description

    {:ok, permissions} = Projects.list_project_permissions()
    refute Enum.empty?(permissions)

    assert {:ok, _} = Projects.delete_project(new_project)
  end
end
