defmodule ExDoppler.Integrations do
  @moduledoc """
  Module for interacting with `ExDoppler.Integration`
  """

  alias ExDoppler.Integration
  alias ExDoppler.Util.Requester

  @integrations_api_path "/v3/integrations"

  @doc """
  Lists `ExDoppler.Integration` using pagination.

  *Returns* `{:ok, %{page: num, configs: [%ExDoppler.Integration{}...]}}` or `{:err, err}`

  See [Doppler Docs](https://docs.doppler.com/reference/integrations-list)
  """
  def list_integrations do
    with {:ok, %{body: body}} <- Requester.get(@integrations_api_path) do
      integrations =
        body["integrations"]
        |> Enum.map(&Integration.build/1)

      {:ok, integrations}
    end
  end

  @doc """
  Same as `list_integrations/0` but won't wrap a successful response in `{:ok, response}`
  """
  def list_integrations! do
    with {:ok, integrations} <- list_integrations() do
      integrations
    end
  end

  @doc """
  Retrieves a `ExDoppler.Integration`, given an integration slug

  *Returns* `{:ok, %ExDoppler.Integration{...}}` or `{:err, err}`

  ## Params
    * **integration_slug**: The relevant integration (e.g `"gh-integration"`)

  See [Doppler Docs](https://docs.doppler.com/reference/integrations-get)
  """
  def get_integration(integration_slug) when is_bitstring(integration_slug) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [integration: integration_slug]) do
      {:ok, Integration.build(body["integration"])}
    end
  end

  @doc """
  Same as `get_integration/1` but won't wrap a successful response in `{:ok, response}`
  """
  def get_integration!(integration_slug) do
    with {:ok, integration} <- get_integration(integration_slug) do
      integration
    end
  end

  @doc """
  Creates a new `ExDoppler.Integration`, given a integration type, name and a data payload

  *Returns* `{:ok, %ExDoppler.Integration{...}}` or `{:err, err}`

  Really, truly - you'll have to look carefully at Doppler's docs.

  ## Params
    * **type**: Integration Type (e.g `"aws_secrets_manager"`)
    * **name**: Integration Name (e.g `"aws-secrets-integration"`)
    * **data**: A map containing fields that are specific to each integration (e.g `%{"aws_assume_role_arn" : "arn..."}`)

  See [Doppler Docs](https://docs.doppler.com/reference/environments-create)
  """
  def create_integration(type, name, data)
      when is_bitstring(type) and is_bitstring(name) and is_map(data) do
    body = %{type: type, name: name, data: data}

    with {:ok, %{body: body}} <- Requester.post(@integrations_api_path, json: body) do
      {:ok, Integration.build(body["integration"])}
    end
  end

  @doc """
  Same as `create_integration/3` but won't wrap a successful response in `{:ok, response}`
  """
  def create_integration!(type, name, data) do
    with {:ok, integration} <- create_integration(type, name, data) do
      integration
    end
  end

  @doc """
  Updates an `ExDoppler.Integration`, given the integration, a new name, and new data payload

  *Returns* `{:ok, %ExDoppler.Integration{...}}` or `{:err, err}`

  Really, truly - you'll have to look carefully at Doppler's docs.

  ## Params
    * **Integration**: Integration to update (e.g `%Integration{slug: "e32d0dcd-c094-4606-aefa-c4127e2a1282"... }`)
    * **data**: A map containing fields that are specific to each integration (e.g `%{"aws_assume_role_arn" : "arn..."}`)

  See [Doppler Docs](https://docs.doppler.com/reference/integrations-update)
  """
  def update_integration(%Integration{slug: slug}, new_name, new_data)
      when is_bitstring(new_name) and is_map(new_data) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    body = %{name: new_name, data: new_data}

    with {:ok, %{body: body}} <- Requester.put(path, qparams: [integration: slug], json: body) do
      {:ok, Integration.build(body["integration"])}
    end
  end

  @doc """
  Same as `update_integration/3` but won't wrap a successful response in `{:ok, response}`
  """
  def update_integration!(%Integration{} = integration, new_name, new_data) do
    with {:ok, integrate} <- update_integration(integration, new_name, new_data) do
      integrate
    end
  end

  @doc """
  Returns the data payload for the integration(?)
  """
  def get_integration_options(integration_slug) when is_bitstring(integration_slug) do
    path =
      @integrations_api_path
      |> Path.join("/integration/options")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [integration: integration_slug]) do
      {:ok, body["options"]}
    end
  end

  @doc """
  Same as `get_integration_options/1` but won't wrap a successful response in `{:ok, response}`
  """
  def get_integration_options!(integration_slug) do
    with {:ok, options} <- get_integration_options(integration_slug) do
      options
    end
  end

  @doc """
  Deletes a `ExDoppler.Integration`

  *Returns* `{:ok, %{success: true}}` or `{:err, err}`

  ## Params
    * **integration**: The relevant integration (e.g `%Integration{slug: "e32d0dcd-c094-4606-aefa-c4127e2a1282"... }`)

  See [Doppler Docs](https://docs.doppler.com/reference/integrations-delete)
  """
  def delete_integration(%Integration{slug: slug}) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    opts = [qparams: [integration: slug]]

    with {:ok, %{body: _}} <- Requester.delete(path, opts) do
      {:ok, %{success: true}}
    end
  end

  @doc """
  Same as `delete_integration/1` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_integration!(%Integration{} = integration) do
    with {:ok, _} <- delete_integration(integration) do
      :ok
    end
  end
end
