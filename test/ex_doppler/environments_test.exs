defmodule ExDoppler.EnvironmentsTest do
  use ExUnit.Case
  doctest ExDoppler.Environments

  alias ExDoppler.Environment
  alias ExDoppler.Environments
  alias ExDoppler.Projects

  test "list_environments/2, get_environment/2" do
    [project | _] = Projects.list_projects!()
    assert project
    assert {:ok, environments} = Environments.list_environments(project)
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
  end

  test "delete_environment/1, create_environment/3, update_environment/2" do
    assert projects = Projects.list_projects!()
    refute Enum.empty?(projects)

    projects
    |> Enum.each(fn project ->
      new_env_name = Faker.Internet.domain_word() |> String.replace("_", "-")
      new_env_slug = Faker.Internet.domain_word() |> String.replace("_", "-")
      Environments.delete_environment(%Environment{project: project.name, slug: new_env_slug})

      assert {:ok, new_env} =
               Environments.create_environment(project, new_env_name, new_env_slug)

      another_name = Faker.Internet.domain_word() |> String.replace("_", "-")

      assert {:ok, new_env} =
               Environments.update_environment(new_env,
                 name: another_name,
                 personal_configs: true
               )

      assert new_env.name == another_name

      assert {:ok, _} = Environments.delete_environment(new_env)
    end)
  end
end
