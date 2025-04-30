defmodule ExDoppler.Auths do
  @moduledoc """
  Module for interacting with `ExDoppler.TokenInfo` and `ExDoppler.ODICToken`

  <!-- tabs-open -->

  ### Resources
    * See: `ExDoppler.TokenInfo`
    * See: `ExDoppler.ODICToken`
    * See: [Doppler API docs](https://docs.doppler.com/reference/auth-me){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """

  alias ExDoppler.ODICToken
  alias ExDoppler.TokenInfo
  alias ExDoppler.Util.Requester

  @doc """
  Get information about the token in use.

  <!-- tabs-open -->
  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.TokenInfo{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/auth-me){:target="_blank"}

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

  ### Params
    * **token**: the OIDC token string from your OIDC provider (likely CI)
    * **identity**: Identity ID from the Doppler Dashboard

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.ODICToken{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/auth-oidc){:target="_blank"}

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

  ### Params
    * **token_to_revoke**: the auth token to revoke (e.g `"auth-2342-asdf"`)

  ### Returns

    **On Success**

    ```elixir
    {:ok, {:success, true}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/auth-revoke){:target="_blank"}

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
