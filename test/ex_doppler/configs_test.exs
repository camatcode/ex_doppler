defmodule ExDoppler.ConfigsTest do
  use ExUnit.Case
  doctest ExDoppler.Configs

  alias ExDoppler.Configs
  alias ExDoppler.Environments
  alias ExDoppler.Projects

  test "Configs" do
    assert {:ok, %{projects: [project | _]}} = Projects.list_projects()
    assert {:ok, %{page: 1, configs: configs}} = Configs.list_configs(project.name)
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
             Environments.list_environments(project.name)

    new_config_name = environment.slug <> "_two-three-four"
    Configs.delete_config(project.name, new_config_name)
    {:ok, new_config} = Configs.create_config(project.name, environment.slug, new_config_name)
    assert new_config.name == new_config_name
    {:ok, _} = Configs.delete_config(project.name, new_config.name)

    assert {:ok, %{page: 1, configs: [_config]}} =
             Configs.list_configs(project.name, per_page: 1)
  end
end
