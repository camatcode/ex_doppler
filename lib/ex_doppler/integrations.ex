defmodule ExDoppler.Integrations do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @integrations_api_path "/v3/integrations"

  def list_integrations() do
    with {:ok, %{body: body}} <- Requester.get(@integrations_api_path) do
      integrations =
        body["integrations"]
        |> Enum.map(&build_integration/1)

      {:ok, integrations}
    end
  end

  def get_integration(integration_slug) when is_bitstring(integration_slug) do
    path =
      @integrations_api_path
      |> Path.join("/integration")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [integration: integration_slug]) do
      {:ok, build_integration(body["integration"])}
    end
  end

  def get_integration_options(integration_slug) when is_bitstring(integration_slug) do
    path =
      @integrations_api_path
      |> Path.join("/integration/options")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [integration: integration_slug]) do
      {:ok, body}
    end
  end

  defp build_integration(integration) do
    fields =
      integration
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Integration, fields)
  end

  defp serialize(:syncs, val) do
    val =
      val
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        key = if key == :lastSyncedAt, do: :last_synced_at, else: key
        {key, val}
      end)

    struct(ExDoppler.Sync, val)
  end

  defp serialize(_, val), do: val
end
