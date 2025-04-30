# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Integrations do
  @moduledoc """
  Module for interacting with `ExDoppler.Integration`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("integrations", "integrations-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Integration
  alias ExDoppler.Util.Requester

  @integrations_api_path "/v3/integrations"

  @doc """
  Lists `ExDoppler.Integration`

  <!-- tabs-open -->
  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.Integration{...}]}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("integrations-list")}

  <!-- tabs-close -->
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
  Retrieves a `ExDoppler.Integration`

  <!-- tabs-open -->

  ### Params
    * **integration_slug**: The relevant integration (e.g `"gh-integration"`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Integration{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("integrations-get")}

  <!-- tabs-close -->
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
  Creates a new `ExDoppler.Integration`


  > #### Read the API docs! {: .warning}
  >
  > The `data` parameter is tailored toward each kind of `type`.

  <!-- tabs-open -->

  ### Params
    * **type**: Integration Type (e.g `"aws_secrets_manager"`)
    * **name**: Integration Name (e.g `"aws-secrets-integration"`)
    * **data**: A map containing fields that are specific to each integration (e.g `%{"aws_assume_role_arn" : "arn..."}`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Integration{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("integrations-create")}

  <!-- tabs-close -->
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
  Updates an `ExDoppler.Integration`

  > #### Read the API docs! {: .warning}
  >
  > The `data` parameter is tailored toward each kind of `type`.

  <!-- tabs-open -->

  ### Params
    * **Integration**: Integration to update (e.g `%Integration{slug: "e32d0dcd-c094-4606-aefa-c4127e2a1282"... }`)
    * **data**: A map containing fields that are specific to each integration (e.g `%{"aws_assume_role_arn" : "arn..."}`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Integration{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("integrations-update")}

  <!-- tabs-close -->
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
  Returns the data payload for the integration

  > #### Read the API docs! {: .warning}
  >
  > These options relate to the `data` payload inside each integration
  > Please use with care

  <!-- tabs-open -->

  ### Params
    * **integration_slug**: Unique identifier for the integration (e.g `"00000000-0000-0000-0000-000000000000"`)

  #{ExDoppler.Doc.returns(success: "{:ok, options}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("get-options")}

  <!-- tabs-close -->
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

  <!-- tabs-open -->

  ### Params
    * **integration**: The relevant integration (e.g `%Integration{slug: "e32d0dcd-c094-4606-aefa-c4127e2a1282"... }`)

  #{ExDoppler.Doc.returns(success: "{:ok, {:success, true}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("integrations-delete")}

  <!-- tabs-close -->
  """
  def delete_integration(%Integration{slug: slug}) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    opts = [qparams: [integration: slug]]

    with {:ok, %{body: _}} <- Requester.delete(path, opts) do
      {:ok, {:success, true}}
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
