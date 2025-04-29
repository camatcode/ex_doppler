defmodule ExDoppler.SecretsSyncs do
  @moduledoc """
  Module for interacting with `ExDoppler.Sync`
  """

  alias ExDoppler.Config
  alias ExDoppler.Integration
  alias ExDoppler.Sync
  alias ExDoppler.Util.Requester

  @secrets_sync_api_path "/v3/configs/config/syncs"

  @doc """
  Retrieves a `ExDoppler.Sync`, given a config and a sync slug

  *Returns* `{:ok, %ExDoppler.Sync{...}}` or `{:err, err}`

  ### Params
   * **config** - Config to get secrets from (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **sync_slug** - Unique ID for the Sync

  See relevant [Doppler Docs](https://docs.doppler.com/reference/syncs-get)
  """
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

  @doc """
  Same as `get_secrets_sync/2` but won't wrap a successful response in `{:ok, response}`
  """
  def get_secrets_sync!(%Config{} = config, sync_slug) do
    with {:ok, sync} <- get_secrets_sync(config, sync_slug) do
      sync
    end
  end

  @doc """
  Creates a new `ExDoppler.Sync`, given a config, an integration, and a data map

  *Returns* `{:ok, %ExDoppler.Sync{...}}` or `{:err, err}`

  Really, truly - read the doppler docs carefully

  ### Params
   * **config** - Config associated with the Sync (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **integration** - Integration associated with the Sync (e.g `%Integration{slug: "e32d0dcd-c094-4606-aefa-c4127e2a1282" ...}`)
   * **data** - A map of data associated with the Sync; the fields will differ depending on the integration

  See relevant [Doppler Docs](https://docs.doppler.com/reference/syncs-create)
  """
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

  @doc """
  Same as `create_secrets_sync/3` but won't wrap a successful response in `{:ok, response}`
  """
  def create_secrets_sync!(%Config{} = config, %Integration{} = integration, data) do
    with {:ok, sync} <- create_secrets_sync(config, integration, data) do
      sync
    end
  end

  @doc """
  Deletes a `ExDoppler.Sync`

  *Returns* `{:ok, %{success: true}}` or `{:err, err}`

  ### Params
   * **config** - Config associated with the Sync (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **sync** - Sync to delete (e.g `%Sync{slug: "e32d0dcd-c094-4606-aefa-c4127e2a1282" ...}`)
   * **delete_from_target** - Whether or not to delete the synced data from the target integration. Defaults to `true`


  See relevant [Doppler Docs](https://docs.doppler.com/reference/syncs-delete)
  """
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

  @doc """
  Same as `delete_secrets_sync/3` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_secrets_sync!(%Config{} = config, %Sync{} = sync, delete_from_target \\ true) do
    with {:ok, _} <- delete_secrets_sync(config, sync, delete_from_target) do
      :ok
    end
  end
end
