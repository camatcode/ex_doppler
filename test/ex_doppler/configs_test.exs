defmodule ExDoppler.ConfigsTest do
  use ExUnit.Case
  doctest ExDoppler.Configs

  alias ExDoppler.Configs
  alias ExDoppler.Environments
  alias ExDoppler.Projects

  test "Configs" do
    assert {:ok, %{projects: [project | _]}} = Projects.list_projects()
    assert {:ok, %{page: 1, configs: configs}} = Configs.list_configs(project)
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

    assert {:ok, %{page: 1, environments: [environment | _]}} =
             Environments.list_environments(project)

    new_config_name = environment.slug <> "_two-three-four"
    Configs.delete_config(project.name, new_config_name)

    assert {:ok, new_config} =
             Configs.create_config(project.name, environment.slug, new_config_name)

    assert new_config.name == new_config_name

    renamed_config_name = "#{environment.slug}_three-four-five"
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

    assert {:ok, %{page: 1, configs: [_config]}} =
             Configs.list_configs(project, per_page: 1)
  end
end
