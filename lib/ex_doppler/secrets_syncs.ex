defmodule ExDoppler.SecretsSyncs do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @secrets_sync_api_path "/v3/configs/config/syncs"

  def get_secrets_sync(project_slug, config_slug, sync_slug)
      when is_bitstring(project_slug) and is_bitstring(config_slug) and is_bitstring(sync_slug) do
    path =
      @secrets_sync_api_path
      |> Path.join("/sync")

    with {:ok, %{body: body}} <-
           Requester.get(path,
             qparams: [project: project_slug, config: config_slug, sync: sync_slug]
           ) do
      {:ok, build_secrets_sync(body["sync"])}
    end
  end

  defp build_secrets_sync(sync) do
    fields =
      sync
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        key = if key == :lastSyncedAt, do: :last_synced_at, else: key
        {key, val}
      end)

    struct(ExDoppler.Sync, fields)
  end
end
