defmodule ExDoppler.SecretsSyncs do
  @moduledoc false

  alias ExDoppler.Sync
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
      {:ok, Sync.build_secrets_sync(body["sync"])}
    end
  end
end
