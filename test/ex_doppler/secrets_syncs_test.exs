defmodule ExDoppler.SecretsSyncsTest do
  use ExUnit.Case
  doctest ExDoppler.SecretsSyncs

  alias ExDoppler.Config
  alias ExDoppler.Configs
  alias ExDoppler.Integrations
  alias ExDoppler.SecretsSyncs

  test "Secrets Syncs" do
    assert {:ok, [integration | _]} = Integrations.list_integrations()

    config = %Config{name: "github", project: "example-project"}

    if !Enum.empty?(integration.syncs) do
      assert {:ok, _} =
               SecretsSyncs.delete_secrets_sync(config, hd(integration.syncs))
    end

    assert {:ok, github_sync} =
             SecretsSyncs.create_secrets_sync(
               config,
               integration,
               %{sync_target: "repo", repo_name: "ex_doppler"}
             )

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

    assert {:ok, _} = SecretsSyncs.delete_secrets_sync(config, github_sync)
  end
end
