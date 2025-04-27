defmodule ExDoppler.SecretsTest do
  use ExUnit.Case
  doctest ExDoppler.Secrets

  alias ExDoppler.Configs
  alias ExDoppler.Projects
  alias ExDoppler.Secrets

  @thirty_min 1800

  test "Secrets" do
    assert {:ok, %{projects: [project | _]}} = Projects.list_projects()
    assert {:ok, %{page: 1, configs: configs}} = Configs.list_configs(project)
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

        {:ok, %ExDoppler.Secret{name: name, raw: raw, computed: computed, note: note}} =
          Secrets.get_secret(config, secret.name)

        assert name == secret.name
        assert raw == secret.raw
        assert computed == secret.computed
        assert note == secret.note

        if !String.starts_with?(secret.name, "DOPPLER") do
          new_value = "hello-three-four-five"

          assert {:ok, updated_secret} =
                   Secrets.update_secret(config, secret.name, new_value, visibility: :masked)

          assert updated_secret.raw == new_value
          assert updated_secret.raw_visibility

          assert {:ok, updated_secret} =
                   Secrets.update_secret(config, secret.name, secret.raw)

          assert raw == updated_secret.raw
        end
      end)

      assert {:ok, sec} =
               Secrets.list_secrets(config,
                 include_dynamic_secrets: true,
                 dynamic_secrets_ttl_sec: @thirty_min
               )

      refute Enum.empty?(sec)

      # json
      assert {:ok, json} = Secrets.download(config)
      assert {:ok, _decoded} = Jason.decode(json)

      # env
      assert {:ok, env} =
               Secrets.download(config,
                 format: "env",
                 name_transformer: "lower-snake"
               )

      assert byte_size(env) != 0

      assert {:ok, names} = Secrets.list_secret_names(config)
      refute Enum.empty?(names)

      secret_name = "NEW_SEC2"
      secret_value = "three-six-twelve"

      Secrets.delete_secret(config, secret_name)

      assert {:ok, new_secret} =
               Secrets.create_secret(config, secret_name, secret_value, visibility: :masked)

      note = "I'm a note"

      assert {:ok, %{note: note, secret: new_secret.name}} ==
               Secrets.update_secret_note(config.project, new_secret.name, note)

      assert {:ok, _} = Secrets.delete_secret(config, new_secret.name)
    end)
  end
end
