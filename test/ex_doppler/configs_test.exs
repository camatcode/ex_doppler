defmodule ExDoppler.ConfigsTest do
  use ExUnit.Case
  doctest ExDoppler.Configs

  alias ExDoppler.Configs
  alias ExDoppler.Environments
  alias ExDoppler.Projects

  test "list_configs/2 and get_config/2" do
    assert [project | _] = Projects.list_projects!()
    assert {:ok, configs} = Configs.list_configs(project)
    refute Enum.empty?(configs)

    configs
    |> Enum.each(fn config ->
      assert config.created_at
      assert config.environment
      assert config.inheritable != nil
      assert config.inheriting != nil
      assert config.inherits
      assert config.locked != nil
      assert config.name
      assert config.project
      assert config.root != nil
      assert config.slug

      assert {:ok, config} == Configs.get_config(config.project, config.name)
    end)
  end

  test "create_config/3, rename_config/3, clone_config/3, lock_config/2, unlock_config/2, delete_config/2" do
    assert [project | _] = Projects.list_projects!()
    assert [environment | _] = Environments.list_environments!(project)

    new_config_name =
      environment.slug <> "_#{Faker.Internet.domain_word() |> String.replace("_", "-")}"

    _ = Configs.delete_config(project.name, new_config_name)

    assert {:ok, new_config} =
             Configs.create_config(project.name, environment.slug, new_config_name)

    assert new_config.name == new_config_name

    renamed_config_name =
      "#{environment.slug}_#{Faker.Internet.domain_word() |> String.replace("_", "-")}"

    Configs.delete_config(project.name, renamed_config_name)

    assert {:ok, new_config} =
             Configs.rename_config(project.name, new_config_name, renamed_config_name)

    assert new_config.name == renamed_config_name

    cloned_config_name = "#{environment.slug}_cloned"
    Configs.delete_config(project.name, cloned_config_name)

    assert {:ok, cloned_config} =
             Configs.clone_config(project.name, new_config.name, cloned_config_name)

    assert cloned_config.name == cloned_config_name

    assert {:ok, cloned_config} = Configs.lock_config(project.name, cloned_config.name)
    assert cloned_config.locked
    assert {:ok, cloned_config} = Configs.unlock_config(project.name, cloned_config.name)
    refute cloned_config.locked

    assert {:ok, _} = Configs.delete_config(project.name, cloned_config.name)
    assert {:ok, _} = Configs.delete_config(project.name, new_config.name)

    assert {:ok, [_config]} =
             Configs.list_configs(project, per_page: 1)
  end
end
