# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ServiceAccounts do
  @moduledoc """
  Module for interacting with `ExDoppler.ServiceAccount`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("service-accounts", "service_accounts-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.ServiceAccount
  alias ExDoppler.Util.Requester

  @service_accounts_api_path "/v3/workplace/service_accounts"

  @doc """
  Lists `ExDoppler.ServiceAccount` using pagination.

  <!-- tabs-open -->

  ### 🏷️ Params
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.ServiceAccount` to return for this page (e.g `per_page: 50`). Default: `20`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.ServiceAccount{...} ...]}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("service_accounts-list")}

  <!-- tabs-close -->
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
