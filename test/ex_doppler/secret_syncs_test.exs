defmodule ExDoppler.SecretSyncsTest do
  use ExUnit.Case

  alias ExDoppler.Config
  alias ExDoppler.Configs
  alias ExDoppler.Integrations
  alias ExDoppler.SecretSyncs

  doctest ExDoppler.SecretSyncs

  test "create_secrets_sync/3, delete_secrets_sync/2, get_secrets_sync/2" do
    assert [integration | _] = Integrations.list_integrations!()

    config = %Config{name: "github", project: "example-project"}

    if !Enum.empty?(integration.syncs) do
      assert {:ok, _} =
               SecretSyncs.delete_secrets_sync(config, hd(integration.syncs))
    end

    assert {:ok, github_sync} =
             SecretSyncs.create_secrets_sync(
               config,
               integration,
               %{sync_target: "repo", repo_name: "ex_doppler"}
             )

    assert {:ok, integrations} = Integrations.list_integrations()

    Enum.each(integrations, fn integration ->
      Enum.each(integration.syncs, fn sync ->
        {:ok, config} = Configs.get_config(sync.project, sync.config)

        assert {:ok, secrets_sync} = SecretSyncs.get_secrets_sync(config, sync.slug)

        assert secrets_sync.slug == sync.slug
      end)
    end)

    assert {:ok, _} = SecretSyncs.delete_secrets_sync(config, github_sync)
  end
end
