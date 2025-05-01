# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Shares do
  @moduledoc """
  Module for interacting with `ExDoppler.Share`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("share-security", "share-secret")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Requester
  alias ExDoppler.Share

  @shares_api_path "/v1/share/secrets"

  @doc """
  Creates a plain-text share link `ExDoppler.Share`

  <!-- tabs-open -->

  ### 🏷️ Params
   * **text_to_share** - Plain text to share (e.g `"sharing this string"`)
    * **opts**: Optional modifications
      * **expire_days** - Days until the link is inaccessible. Default: `90`
      * **expire_views** - Number of views until the link is inaccessible. -1 means infinite. Default: `-1`

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Share{...}}", failure: "{:err, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Shares
      iex> {:ok, _share} = Shares.plain_text("SHARE_THIS_TEXT", expire_days: 1, expire_views: 1)

  #{ExDoppler.Doc.resources("share-secret")}

  <!-- tabs-close -->
  """
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

  @doc """
  Same as `plain_text/2` but won't wrap a successful response in `{:ok, response}`
  """
  def plain_text!(text_to_share, opts \\ []) do
    with {:ok, share} <- plain_text(text_to_share, opts) do
      share
    end
  end
end
