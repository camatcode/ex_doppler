defmodule ExDoppler.ServiceTokensTest do
  use ExUnit.Case
  doctest ExDoppler.ServiceTokens

  alias ExDoppler.Configs
  alias ExDoppler.Projects
  alias ExDoppler.ServiceToken
  alias ExDoppler.ServiceTokens

  test "Configs" do
    assert {:ok, %{projects: [project | _]}} = Projects.list_projects()
    assert {:ok, %{page: 1, configs: configs}} = Configs.list_configs(project)
    refute Enum.empty?(configs)

    configs
    |> Enum.each(fn config ->
      token_slug = "my-service-token"

      ServiceTokens.delete_service_token(%ServiceToken{
        project: config.project,
        config: config.name,
        slug: token_slug
      })

      {:ok, service_token} = ServiceTokens.create_service_token(config, token_slug)

      {:ok, service_tokens} = ServiceTokens.list_service_tokens(config)

      service_tokens
      |> Enum.each(fn service_token ->
        assert service_token.name
        assert service_token.slug
        assert service_token.created_at
        assert service_token.config
        assert service_token.environment
        assert service_token.project
      end)

      {:ok, _} = ServiceTokens.delete_service_token(service_token)
    end)
  end
end
