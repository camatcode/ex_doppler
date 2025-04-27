defmodule ExDoppler.SecretsSyncsTest do
  use ExUnit.Case
  doctest ExDoppler.SecretsSyncs

  alias ExDoppler.Configs
  alias ExDoppler.Integrations
  alias ExDoppler.SecretsSyncs

  test "Secrets Syncs" do
    assert {:ok, integrations} = Integrations.list_integrations()

    integrations
    |> Enum.each(fn integration ->
      integration.syncs
      |> Enum.each(fn sync ->
        {:ok, config} = Configs.get_config(sync.project, sync.config)

        assert {:ok, secrets_sync} =
                 SecretsSyncs.get_secrets_sync(config, sync.slug)

        assert secrets_sync.slug == sync.slug
      end)
    end)
  end
end
