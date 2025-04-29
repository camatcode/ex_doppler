defmodule ExDoppler.ServiceAccounts do
  @moduledoc """
  Module for interacting with `ExDoppler.ServiceAccount`
  """

  alias ExDoppler.ServiceAccount
  alias ExDoppler.Util.Requester

  @service_accounts_api_path "/v3/workplace/service_accounts"

  @doc """
  Lists `ExDoppler.ServiceAccount` using pagination.

  *Returns* `{:ok, [%ExDoppler.ServiceAccount{}...]}` or `{:err, err}`

  ## Params
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.ServiceAccount` to return for this page (e.g `per_page: 50`). Default: `20`

  See [Doppler Docs](https://docs.doppler.com/reference/service_accounts-list)
  """
  def list_service_accounts(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@service_accounts_api_path, qparams: opts) do
      accounts =
        body["service_accounts"]
        |> Enum.map(&ServiceAccount.build/1)

      {:ok, accounts}
    end
  end

  @doc """
  Same as `list_service_accounts/1` but won't wrap a successful response in `{:ok, response}`
  """
  def list_service_accounts!(opts \\ []) do
    with {:ok, accounts} <- list_service_accounts(opts) do
      accounts
    end
  end
end
