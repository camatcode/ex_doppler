# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ServiceTokens do
  @moduledoc """
  Module for interacting with `ExDoppler.ServiceToken`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("service-tokens", "service_tokens-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Config
  alias ExDoppler.Requester
  alias ExDoppler.ServiceToken

  @service_tokens_api_path "/v3/configs/config/tokens"

  @doc """
  Lists `ExDoppler.ServiceAccount`

  <!-- tabs-open -->

  ### 🏷️ Params
   * **config** - Config associated with the tokens (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.ServiceToken{...} ...]}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Config
      iex> alias ExDoppler.ServiceTokens
      iex> config = %Config{name: "dev", project: "example-project"}
      iex> {:ok, _tokens} = ServiceTokens.list_service_tokens(config)

  #{ExDoppler.Doc.resources("service_tokens-list")}

  <!-- tabs-close -->
  """
  def list_service_tokens(%Config{name: config_name, project: project_name}) do
    with {:ok, %{body: body}} <-
           Requester.get(@service_tokens_api_path,
             qparams: [project: project_name, config: config_name]
           ) do
      tokens = Enum.map(body["tokens"], &ServiceToken.build/1)

      {:ok, tokens}
    end
  end

  @doc """
  Same as `list_service_tokens/1` but won't wrap a successful response in `{:ok, response}`
  """
  def list_service_tokens!(%Config{} = config) do
    with {:ok, tokens} <- list_service_tokens(config) do
      tokens
    end
  end

  @doc """
  Creates a new `ExDoppler.ServiceToken`, given a Config, a name and optional modifications

  <!-- tabs-open -->

  ### 🏷️ Params
   * **config** - Config associated with the tokens (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
    * **service_token_name**: Name of this token (e.g `"cli_token"`)
    * **opts**: Optional modifications to the list call
      * **expire_at** - Unix timestamp of when token should expire. Default: `nil`
      * **access** - Token's capabilities. `"read"` or `"read/write"`. Default: `"read"`

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.ServiceToken{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Config
      iex> alias ExDoppler.ServiceToken
      iex> alias ExDoppler.ServiceTokens
      iex> config = %Config{name: "dev", project: "example-project"}
      iex> token_slug = "my-service-token"
      iex> _ = ServiceTokens.delete_service_token!(%ServiceToken{project: config.project, config: config.name, slug: token_slug})
      iex> {:ok, service_token} = ServiceTokens.create_service_token(config, token_slug)
      iex> :ok = ServiceTokens.delete_service_token!(service_token)

  #{ExDoppler.Doc.resources("service_tokens-create")}

  <!-- tabs-close -->
  """
  def create_service_token(%Config{name: config_name, project: project_name}, service_token_name, opts \\ [])
      when is_bitstring(service_token_name) do
    opts = Keyword.merge([expire_at: nil, access: :read], opts)

    body =
      %{
        project: project_name,
        config: config_name,
        name: service_token_name,
        expire_at: opts[:expire_at],
        access: opts[:access]
      }
      |> Enum.filter(fn {_k, v} -> v end)
      |> Map.new()

    with {:ok, %{body: body}} <- Requester.post(@service_tokens_api_path, json: body) do
      {:ok, ServiceToken.build(body["token"])}
    end
  end

  @doc """
  Same as `create_service_token/3` but won't wrap a successful response in `{:ok, response}`
  """
  def create_service_token!(%Config{} = config, service_token_name, opts \\ []) do
    with {:ok, token} <- create_service_token(config, service_token_name, opts) do
      token
    end
  end

  @doc """
  Deletes a `ExDoppler.ServiceToken`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **service_token**: The token to delete (e.g `%ServiceToken{project: "example-project", config: "dev_personal", slug: "56c69f96-3045-11ea-978f-2e728ce8812"}`)

  #{ExDoppler.Doc.returns(success: "{:ok, {:success, true}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Config
      iex> alias ExDoppler.ServiceToken
      iex> alias ExDoppler.ServiceTokens
      iex> config = %Config{name: "dev", project: "example-project"}
      iex> token_slug = "my-service-token"
      iex> _ = ServiceTokens.delete_service_token!(%ServiceToken{project: config.project, config: config.name, slug: token_slug})
      iex> {:ok, service_token} = ServiceTokens.create_service_token(config, token_slug)
      iex> :ok = ServiceTokens.delete_service_token!(service_token)
    
  #{ExDoppler.Doc.resources("service_tokens-delete")}

  <!-- tabs-close -->
  """
  def delete_service_token(%ServiceToken{project: project_name, config: config_name, slug: slug}) do
    body = %{project: project_name, config: config_name, slug: slug}

    path = Path.join(@service_tokens_api_path, "/token")

    with {:ok, %{body: _}} <- Requester.delete(path, json: body) do
      {:ok, {:success, true}}
    end
  end

  @doc """
  Same as `delete_service_token/1` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_service_token!(%ServiceToken{} = token) do
    with {:ok, _} <- delete_service_token(token) do
      :ok
    end
  end
end
