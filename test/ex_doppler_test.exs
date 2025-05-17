defmodule ExDopplerTest do
  use ExUnit.Case

  alias ExDoppler.Configs
  alias ExDoppler.Projects
  alias ExDoppler.Secrets

  doctest ExDoppler

  test "get_secret_raw/3 and get_secret_raw!/3" do
    assert [project | _] = Projects.list_projects!()
    assert configs = Configs.list_configs!(project)
    refute Enum.empty?(configs)

    Enum.each(configs, fn config ->
      {:ok, secrets} = Secrets.list_secrets(config)
      refute Enum.empty?(secrets)

      Enum.each(secrets, fn secret ->
        assert secret.name
        assert secret.raw
        assert secret.computed
        assert secret.note
        assert secret.raw_visibility
        assert secret.computed_visibility

        {:ok, raw} = ExDoppler.get_secret_raw(project.name, config.name, secret.name)
        assert raw == secret.raw

        raw = ExDoppler.get_secret_raw!(project.name, config.name, secret.name)
        assert raw == secret.raw
      end)
    end)
  end
end
