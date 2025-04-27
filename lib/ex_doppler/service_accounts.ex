defmodule ExDoppler.ServiceAccounts do
  @moduledoc false

  alias ExDoppler.ServiceAccount
  alias ExDoppler.Util.Requester

  @service_accounts_api_path "/v3/workplace/service_accounts"

  def list_service_accounts(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@service_accounts_api_path, qparams: opts) do
      accounts =
        body["service_accounts"]
        |> Enum.map(&ServiceAccount.build_service_account/1)

      {:ok, accounts}
    end
  end
end
