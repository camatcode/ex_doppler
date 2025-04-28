defmodule ExDoppler.ServiceTokens do
  @moduledoc false

  alias ExDoppler.Config
  alias ExDoppler.ServiceToken
  alias ExDoppler.Util.Requester

  @service_tokens_api_path "/v3/configs/config/tokens"

  def list_service_tokens(%Config{name: config_name, project: project_name}) do
    with {:ok, %{body: body}} <-
           Requester.get(@service_tokens_api_path,
             qparams: [project: project_name, config: config_name]
           ) do
      tokens =
        body["tokens"]
        |> Enum.map(&ServiceToken.build/1)

      {:ok, tokens}
    end
  end

  def list_service_tokens!(%Config{} = config) do
    with {:ok, tokens} <- list_service_tokens(config) do
      tokens
    end
  end

  def create_service_token(
        %Config{name: config_name, project: project_name},
        service_token_name,
        opts \\ []
      )
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
      |> Enum.into(%{})

    with {:ok, %{body: body}} <- Requester.post(@service_tokens_api_path, json: body) do
      {:ok, ServiceToken.build(body["token"])}
    end
  end

  def create_service_token!(%Config{} = config, service_token_name, opts \\ []) do
    with {:ok, token} <- create_service_token(config, service_token_name, opts) do
      token
    end
  end

  def delete_service_token(%ServiceToken{project: project_name, config: config_name, slug: slug}) do
    body = %{project: project_name, config: config_name, slug: slug}

    path =
      @service_tokens_api_path
      |> Path.join("/token")

    with {:ok, %{body: _}} <- Requester.delete(path, json: body) do
      {:ok, {:success, true}}
    end
  end

  def delete_service_token!(%ServiceToken{} = token) do
    with {:ok, _} <- delete_service_token(token) do
      :ok
    end
  end
end
