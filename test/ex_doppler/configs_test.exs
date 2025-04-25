defmodule ExDoppler.ConfigsTest do
  use ExUnit.Case
  doctest ExDoppler.Configs

  alias ExDoppler.Configs
  alias ExDoppler.Projects

  test "Configs" do
    assert {:ok, %{page: 1, configs: configs}} = Configs.list_configs()
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

    assert {:ok, %{projects: [project | _]}} = Projects.list_projects()

    assert {:ok, %{page: 1, configs: [config]}} =
             Configs.list_configs(project: project.name, per_page: 1)
  end
end
