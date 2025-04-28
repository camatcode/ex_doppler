defmodule ExDoppler.Auths do
  @moduledoc false

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
end
