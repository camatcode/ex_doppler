defmodule ExDoppler.EnvironmentsTest do
  use ExUnit.Case
  doctest ExDoppler.Environments

  alias ExDoppler.Environment
  alias ExDoppler.Environments
  alias ExDoppler.Projects

  test "Environments" do
    assert {:ok, projects} = Projects.list_projects()
    refute Enum.empty?(projects)

    projects
    |> Enum.each(fn project ->
      new_env_name = "env-one-two"
      new_env_slug = "eot"
      Environments.delete_environment(%Environment{project: project.name, slug: new_env_slug})

      assert {:ok, new_env} =
               Environments.create_environment(project, new_env_name, new_env_slug)

      assert {:ok, new_env} =
               Environments.update_environment(new_env,
                 name: "new-name",
                 personal_configs: true
               )

      assert new_env.name == "new-name"

      assert {:ok, environments} =
               Environments.list_environments(project)

      refute Enum.empty?(environments)

      environments
      |> Enum.each(fn env ->
        assert env.created_at
        assert env.id
        assert env.name
        assert env.project
        assert env.slug

        assert {:ok, env} == Environments.get_environment(project, env.slug)
      end)

      assert {:ok, [_env]} =
               Environments.list_environments(project, per_page: 1)

      assert {:ok, _} = Environments.delete_environment(new_env)
    end)
  end
end
