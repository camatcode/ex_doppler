defmodule ExDoppler.Invites do
  @moduledoc """
  Module for interacting with `ExDoppler.Invite`
  """

  alias ExDoppler.Invite
  alias ExDoppler.Util.Requester

  @invites_api_path "/v3/workplace/invites"

  @doc """
  Lists `ExDoppler.Invite`

  <!-- tabs-open -->

  ### Params
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.Invite` to return for this page (e.g `per_page: 50`). Default: `20`

  ### Returns

    **On Success**

    ```elixir
    {:ok, [%ExDoppler.Invite{...} ...]}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Doppler Docs

  See relevant [Doppler Docs](https://docs.doppler.com/reference/invites-list){:target="_blank"}
  <!-- tabs-close -->
  """
  def list_invites(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@invites_api_path, qparams: opts) do
      invites =
        body["invites"]
        |> Enum.map(&Invite.build/1)

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
