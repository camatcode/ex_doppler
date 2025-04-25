defmodule ExDoppler.SecretsTest do
  use ExUnit.Case
  doctest ExDoppler.Secrets

  alias ExDoppler.Configs
  alias ExDoppler.Secrets

  @thirty_min 1800

  test "Secrets" do
    assert {:ok, %{page: 1, configs: configs}} = Configs.list_configs()
    refute Enum.empty?(configs)

    configs
    |> Enum.each(fn config ->
      {:ok, secrets} = Secrets.list_secrets(config.project, config.name)
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
          Secrets.get_secret(config.project, config.name, secret.name)

        assert name == secret.name
        assert raw == secret.raw
        assert computed == secret.computed
        assert note == secret.note
      end)

      assert {:ok, sec} =
               Secrets.list_secrets(config.project, config.name,
                 include_dynamic_secrets: true,
                 dynamic_secrets_ttl_sec: @thirty_min
               )

      refute Enum.empty?(sec)
    end)
  end
end
