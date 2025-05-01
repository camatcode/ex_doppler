defmodule ExDoppler.IntegrationsTest do
  use ExUnit.Case
  doctest ExDoppler.Integrations

  alias ExDoppler.Integrations

  test "list_integrations/0, get_integration/1, get_integration_options/1" do
    assert {:ok, integrations} = Integrations.list_integrations()

    integrations
    |> Enum.each(fn integration ->
      assert integration.slug
      assert integration.name
      assert integration.type
      assert integration.kind
      assert integration.enabled != nil

      {:ok, retrieved_integration} = Integrations.get_integration(integration.slug)
      assert retrieved_integration.slug == integration.slug

      assert {:ok, options} = Integrations.get_integration_options(integration.slug)
      assert options
    end)
  end
end
