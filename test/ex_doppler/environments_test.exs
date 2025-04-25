defmodule ExDoppler.EnvironmentsTest do
  use ExUnit.Case
  doctest ExDoppler.Environments

  alias ExDoppler.Environments
  alias ExDoppler.Projects

  test "Environments" do
    assert {:ok, %{page: 1, projects: projects}} = Projects.list_projects()
    refute Enum.empty?(projects)

    projects
    |> Enum.each(fn project ->
      assert {:ok, %{page: 1, environments: environments}} =
               Environments.list_environments(project.name)

      refute Enum.empty?(environments)

      environments
      |> Enum.each(fn env ->
        assert env.created_at
        assert env.id
        assert env.name
        assert env.project
        assert env.slug

        assert {:ok, env} == Environments.get_environment(env.project, env.slug)
      end)

      assert {:ok, %{page: 1, environments: [_env]}} =
               Environments.list_environments(project.name, per_page: 1)
    end)
  end
end
