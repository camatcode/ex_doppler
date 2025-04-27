defmodule ExDoppler.SecretsSyncsTest do
  use ExUnit.Case
  doctest ExDoppler.SecretsSyncs

  alias ExDoppler.Integrations
  alias ExDoppler.SecretsSyncs

  test "Secrets Syncs" do
    assert {:ok, integrations} = Integrations.list_integrations()

    integrations
    |> Enum.each(fn integration ->
      integration.syncs
      |> Enum.each(fn sync ->
        assert {:ok, secrets_sync} =
                 SecretsSyncs.get_secrets_sync(sync.project, sync.config, sync.slug)

        assert secrets_sync.slug == sync.slug
      end)
    end)
  end
end
