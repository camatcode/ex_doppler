# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Auths do
  @moduledoc """
  Module for interacting with `ExDoppler.TokenInfo` and `ExDoppler.ODICToken`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("service-account-identities", "auth-me")}

  <!-- tabs-close -->
  """

  alias ExDoppler.ODICToken
  alias ExDoppler.Requester
  alias ExDoppler.TokenInfo

  @doc """
  Get information about the token in use.

  <!-- tabs-open -->
  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.TokenInfo{...}}", failure: "{:err, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.TokenInfo
      iex> alias ExDoppler.Auths
      iex> {:ok, _token_info = %TokenInfo{}} = Auths.me()

  #{ExDoppler.Doc.resources("auth-me")}

  <!-- tabs-close -->
  """
  def me do
    path = "/v3/me"

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, TokenInfo.build(body)}
    end
  end

  @doc """
  Same as `me/0` but won't wrap a successful response in `{:ok, response}`
  """
  def me! do
    with {:ok, token_info} <- me() do
      token_info
    end
  end

  @doc """
  Authenticate via a Service Account Identity with OIDC. Returns a short-lived API token.

  <!-- tabs-open -->

  ### 🏷️ Params
    * **token**: the OIDC token string from your OIDC provider (likely CI)
    * **identity**: Identity ID from the Doppler Dashboard

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.ODICToken{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("auth-oidc")}

  <!-- tabs-close -->
  """
  def odic(token, identity) when is_bitstring(token) and is_bitstring(identity) do
    opts = [json: %{token: token, identity: identity}]
    path = "/v3/auth/odic"

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, ODICToken.build(body)}
    end
  end

  @doc """
  Same as `odic/2` but won't wrap a successful response in `{:ok, response}`
  """
  def odic!(token, identity) do
    with {:ok, odic_token} <- odic(token, identity) do
      odic_token
    end
  end

  @doc """
  Revoke an auth token

  <!-- tabs-open -->

  ### 🏷️ Params
    * **token_to_revoke**: the auth token to revoke (e.g `"auth-2342-asdf"`)

  #{ExDoppler.Doc.returns(success: "{:ok, {:success, true}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("auth-revoke")}

  <!-- tabs-close -->
  """
  def revoke_auth_token(token_to_revoke) when is_bitstring(token_to_revoke) do
    opts = [json: %{token: token_to_revoke}]
    path = "/v3/auth/revoke"

    with {:ok, %{body: _}} <- Requester.post(path, opts) do
      {:ok, {:success, true}}
    end
  end

  @doc """
  Same as `revoke_auth_token/1` but won't wrap a successful response in `{:ok, response}`
  """
  def revoke_auth_token!(token_to_delete) do
    with {:ok, _} <- revoke_auth_token(token_to_delete) do
      :ok
    end
  end
end
