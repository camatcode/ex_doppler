defmodule ExDoppler.ProjectsTest do
  use ExUnit.Case
  doctest ExDoppler.Projects

  alias ExDoppler.Projects

  test "Projects" do
    {:ok, %{page: 1, projects: projects}} = Projects.list_projects()
    refute Enum.empty?(projects)

    projects
    |> Enum.each(fn project ->
      assert project.created_at
      assert project.description
      assert project.id
      assert project.name
      assert project.slug
    end)

    assert {:ok, %{page: 1, projects: [project]}} = Projects.list_projects(per_page: 1)
    assert project.id
  end
end
