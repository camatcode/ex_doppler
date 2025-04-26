defmodule ExDoppler.IntegrationsTest do
  use ExUnit.Case
  doctest ExDoppler.Integrations

  alias ExDoppler.Integration
  alias ExDoppler.Integrations

  test "Integrations" do
    assert {:ok, integrations} = Integrations.list_integrations()

    integrations
    |> Enum.each(fn integration ->
      assert integration.slug
      assert integration.name
      assert integration.type
      assert integration.kind
      assert integration.enabled != nil

      assert {:ok, %Integration{slug: integration.slug}} ==
               Integrations.get_integration(integration.slug)
    end)
  end
end
