defmodule ExDoppler.Auths do
  @moduledoc false

  alias ExDoppler.ODICToken
  alias ExDoppler.TokenInfo
  alias ExDoppler.Util.Requester

  def me do
    path = "/v3/me"

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, TokenInfo.build(body)}
    end
  end

  def me! do
    with {:ok, token_info} <- me() do
      token_info
    end
  end

  def odic(token, identity) when is_bitstring(token) and is_bitstring(identity) do
    opts = [json: %{token: token, identity: identity}]
    path = "/v3/auth/odic"

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, ODICToken.build(body)}
    end
  end

  def odic!(token, identity) do
    with {:ok, odic_token} <- odic(token, identity) do
      odic_token
    end
  end

  def revoke_auth_token(token_to_delete) when is_bitstring(token_to_delete) do
    opts = [json: %{token: token_to_delete}]
    path = "/v3/auth/revoke"

    with {:ok, %{body: _}} <- Requester.post(path, opts) do
      {:ok, %{success: true}}
    end
  end

  def revoke_auth_token!(token_to_delete) do
    with {:ok, _} <- revoke_auth_token(token_to_delete) do
      :ok
    end
  end
end
