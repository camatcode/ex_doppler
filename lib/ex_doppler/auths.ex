defmodule ExDoppler.Auths do
  @moduledoc false

  alias ExDoppler.TokenInfo
  alias ExDoppler.Util.Requester

  def me do
    path = "/v3/me"

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, TokenInfo.build_token_info(body)}
    end
  end
end
