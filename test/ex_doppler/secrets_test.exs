defmodule ExDoppler.SecretsTest do
  use ExUnit.Case
  doctest ExDoppler.Secrets

  alias ExDoppler.Config
  alias ExDoppler.Configs
  alias ExDoppler.Projects
  alias ExDoppler.Secrets

  test "list_secrets/1, get_secret/2, download/2, list_secret_names/2" do
    assert [project | _] = Projects.list_projects!()
    assert configs = Configs.list_configs!(project)
    refute Enum.empty?(configs)

    configs
    |> Enum.each(fn config ->
      {:ok, secrets} = Secrets.list_secrets(config)
      refute Enum.empty?(secrets)

      secrets
      |> Enum.each(fn secret ->
        assert secret.name
        assert secret.raw
        assert secret.computed
        assert secret.note
        assert secret.raw_visibility
        assert secret.computed_visibility

        assert {:ok, secret} == Secrets.get_secret(config, secret.name)
        assert {:ok, json} = Secrets.download(config)
        assert {:ok, _decoded} = Jason.decode(json)

        assert {:ok, names} = Secrets.list_secret_names(config)
        refute Enum.empty?(names)
      end)
    end)
  end

  test "create_secret/2, update_secret/4, update_secret_note/3, delete_secret/2" do
    config_name = "dev_personal"
    project_name = "example-project"
    config = %Config{name: config_name, project: project_name}
    name = Faker.Internet.domain_word() |> String.replace("_", "-") |> String.upcase()
    value = Faker.Internet.domain_word() |> String.replace("_", "-")
    Secrets.delete_secret(config, name)
    {:ok, _} = Secrets.create_secret(config, name, value)
    new_value = Faker.Internet.domain_word() |> String.replace("_", "-")
    {:ok, updated} = Secrets.update_secret(config, name, new_value, visibility: :unmasked)
    assert updated.raw == new_value
    new_note = Faker.Internet.domain_word() |> String.replace("_", "-")
    {:ok, updated} = Secrets.update_secret_note(project_name, name, new_note)
    assert updated.note == new_note
    :ok = Secrets.delete_secret!(config, name)
  end
end
