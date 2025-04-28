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
end
