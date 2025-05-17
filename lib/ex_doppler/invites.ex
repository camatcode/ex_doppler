# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Invites do
  @moduledoc """
  Module for interacting with `ExDoppler.Invite`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("workplace-team#send-invite", "invites-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Invite
  alias ExDoppler.Requester

  @invites_api_path "/v3/workplace/invites"

  @doc """
  Lists `ExDoppler.Invite`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.Invite` to return for this page (e.g `per_page: 50`). Default: `20`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.Invite{...}]}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.Invites
      iex> {:ok, _invites} = Invites.list_invites()

  #{ExDoppler.Doc.resources("invites-list")}

  <!-- tabs-close -->
  """
  def list_invites(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@invites_api_path, qparams: opts) do
      invites = Enum.map(body["invites"], &Invite.build/1)

      {:ok, invites}
    end
  end

  @doc """
  Same as `list_invites/1` but won't wrap a successful response in `{:ok, response}`
  """
  def list_invites!(opts \\ []) do
    with {:ok, invites} <- list_invites(opts) do
      invites
    end
  end
end
