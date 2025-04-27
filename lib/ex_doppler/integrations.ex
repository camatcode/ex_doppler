defmodule ExDoppler.Integrations do
  @moduledoc false

  alias ExDoppler.Integration
  alias ExDoppler.Util.Requester

  @integrations_api_path "/v3/integrations"

  def list_integrations do
    with {:ok, %{body: body}} <- Requester.get(@integrations_api_path) do
      integrations =
        body["integrations"]
        |> Enum.map(&Integration.build_integration/1)

      {:ok, integrations}
    end
  end

  def get_integration(integration_slug) when is_bitstring(integration_slug) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [integration: integration_slug]) do
      {:ok, Integration.build_integration(body["integration"])}
    end
  end

  def get_integration_options(integration_slug) when is_bitstring(integration_slug) do
    path =
      @integrations_api_path
      |> Path.join("/integration/options")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [integration: integration_slug]) do
      {:ok, body}
    end
  end
end
