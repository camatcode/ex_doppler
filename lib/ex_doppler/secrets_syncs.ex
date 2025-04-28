defmodule ExDoppler.SecretsSyncs do
  @moduledoc false

  alias ExDoppler.Config
  alias ExDoppler.Integration
  alias ExDoppler.Sync
  alias ExDoppler.Util.Requester

  @secrets_sync_api_path "/v3/configs/config/syncs"

  def get_secrets_sync(%Config{name: config_name, project: project_slug}, sync_slug)
      when is_bitstring(sync_slug) do
    path =
      @secrets_sync_api_path
      |> Path.join("/sync")

    with {:ok, %{body: body}} <-
           Requester.get(path,
             qparams: [project: project_slug, config: config_name, sync: sync_slug]
           ) do
      {:ok, Sync.build(body["sync"])}
    end
  end

  def get_secrets_sync!(%Config{} = config, sync_slug) do
    with {:ok, sync} <- get_secrets_sync(config, sync_slug) do
      sync
    end
  end

  def create_secrets_sync(
        %Config{name: config_name, project: project_slug},
        %Integration{slug: slug},
        data
      )
      when is_map(data) do
    body = %{integration: slug, data: data}
    opts = [qparams: [project: project_slug, config: config_name], json: body]

    with {:ok, %{body: body}} <- Requester.post(@secrets_sync_api_path, opts) do
      {:ok, Sync.build(body["sync"])}
    end
  end

  def create_secrets_sync!(%Config{} = config, %Integration{} = integration, data) do
    with {:ok, sync} <- create_secrets_sync(config, integration, data) do
      sync
    end
  end

  def delete_secrets_sync(
        %Config{name: config_name, project: project_slug},
        %Sync{slug: slug},
        delete_from_target \\ true
      )
      when is_boolean(delete_from_target) do
    path =
      @secrets_sync_api_path
      |> Path.join("/sync")

    opts = [
      qparams: [
        project: project_slug,
        config: config_name,
        sync: slug,
        delete_from_target: delete_from_target
      ]
    ]

    with {:ok, %{body: _}} <- Requester.delete(path, opts) do
      {:ok, %{success: true}}
    end
  end

  def delete_secrets_sync!(%Config{} = config, %Sync{} = sync, delete_from_target \\ true) do
    with {:ok, _} <- delete_secrets_sync(config, sync, delete_from_target) do
      :ok
    end
  end
end
