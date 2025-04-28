defmodule ExDoppler.Integrations do
  @moduledoc false

  alias ExDoppler.Integration
  alias ExDoppler.Util.Requester

  @integrations_api_path "/v3/integrations"

  def list_integrations do
    with {:ok, %{body: body}} <- Requester.get(@integrations_api_path) do
      integrations =
        body["integrations"]
        |> Enum.map(&Integration.build/1)

      {:ok, integrations}
    end
  end

  def list_integrations! do
    with {:ok, integrations} <- list_integrations() do
      integrations
    end
  end

  def get_integration(integration_slug) when is_bitstring(integration_slug) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [integration: integration_slug]) do
      {:ok, Integration.build(body["integration"])}
    end
  end

  def get_integration!(integration_slug) do
    with {:ok, integration} <- get_integration(integration_slug) do
      integration
    end
  end

  def create_integration(type, name, data)
      when is_bitstring(type) and is_bitstring(name) and is_map(data) do
    body = %{type: type, name: name, data: data}

    with {:ok, %{body: body}} <- Requester.post(@integrations_api_path, json: body) do
      {:ok, Integration.build(body["integration"])}
    end
  end

  def create_integration!(type, name, data) do
    with {:ok, integration} <- create_integration(type, name, data) do
      integration
    end
  end

  def update_integration(%Integration{slug: slug}, new_name, new_data)
      when is_bitstring(new_name) and is_map(new_data) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    body = %{name: name, data: data}

    with {:ok, %{body: body}} <- Requester.put(path, qparams: [integration: slug], json: body) do
      {:ok, Integration.build(body["integration"])}
    end
  end

  def update_integration!(%Integration{} = integration, new_name, new_data) do
    with {:ok, integrate} <- update_integration(integration, new_name, new_data) do
      integrate
    end
  end

  def get_integration_options(integration_slug) when is_bitstring(integration_slug) do
    path =
      @integrations_api_path
      |> Path.join("/integration/options")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [integration: integration_slug]) do
      {:ok, body["options"]}
    end
  end

  def get_integration_options!(integration_slug) do
    with {:ok, options} <- get_integration_options(integration_slug) do
      options
    end
  end

  def delete_integration(%Integration{slug: slug}) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    opts = [qparams: [integration: slug]]

    with {:ok, %{body: _}} <- Requester.delete(path, opts) do
      {:ok, %{success: true}}
    end
  end

  def delete_integration!(%Integration{} = integration) do
    with {:ok, _} <- delete_integration(integration) do
      :ok
    end
  end
end
