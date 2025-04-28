defmodule ExDoppler.Shares do
  @moduledoc false

  alias ExDoppler.Share
  alias ExDoppler.Util.Requester

  @shares_api_path "/v1/share/secrets"

  def plain_text(text_to_share, opts \\ []) when is_bitstring(text_to_share) do
    opts = Keyword.merge([expire_days: 90, expire_views: -1], opts)

    path =
      @shares_api_path
      |> Path.join("/plain")

    body = %{
      secret: text_to_share,
      expire_days: opts[:expire_days],
      expire_views: opts[:expire_views]
    }

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Share.build(body)}
    end
  end

  def plain_text!(text_to_share, opts \\ []) do
    with {:ok, share} <- plain_text(text_to_share, opts) do
      share
    end
  end
end
