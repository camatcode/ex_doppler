defmodule ExDoppler.ServiceAccounts do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @service_accounts_api_path "/v3/workplace/service_accounts"

  def list_service_accounts(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@service_accounts_api_path, qparams: opts) do
      accounts =
        body["service_accounts"]
        |> Enum.map(&build_service_account/1)

      {:ok, accounts}
    end
  end

  defp build_service_account(account) do
    fields =
      account
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ServiceAccount, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:workplace_role, val) do
    val =
      val
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.WorkplaceRole, val)
  end

  defp serialize(_, val), do: val
end
