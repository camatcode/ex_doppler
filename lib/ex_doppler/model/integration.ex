# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Integration do
  @moduledoc """
  Module describing an Integration

  <!-- tabs-open -->
  ### Fields
    * `slug` - Unique identifier for the object  (e.g `"e32d0dcd-c094-4606-aefa-c4127e2a1282"`)
    * `name` - Unique identifier for the object (e.g `"Cloudflare Integration"`)
    * `type` - Provider of integration (e.g `"cloudflare_tokens"`)
    * `kind` - Class of integration (e.g `"rotatedSecrets"`)
    * `enabled` - Whether integration is enabled (e.g `true`)
    * `syncs` - List of Syncs. See `ExDoppler.Sync`

  #{ExDoppler.Doc.resources("integrations", "integrations-list")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  alias ExDoppler.Sync

  defstruct [:slug, :name, :type, :kind, :enabled, :syncs]

  @doc """
  Creates an `Integration` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **integration**: Map of fields to turn into a `Integration`

  <!-- tabs-close -->
  """
  def build(%{} = integration) do
    fields =
      integration
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Integration, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:syncs, val), do: val |> Enum.map(&Sync.build/1)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.Sync do
  @moduledoc """
  Module describing a Sync

  <!-- tabs-open -->
  ### Fields
    * `slug` - Unique identifier for the object  (e.g `"0cd84923-b8c5-49e6-8713-e6ea2148a6c1"`)
    * `enabled` - Whether sync is enabled (e.g `true`)
    * `last_synced_at` - Date and Time of last sync (e.g `"2025-04-28T16:09:17.737Z"`)
    * `project` - Unique identifier for the project object (e.g `"example-project"`)
    * `config` - Relevant config (e.g `"prd"`)
    * `integration` - Relevant integration slug (e.g `"e32d0dcd-c094-4606-aefa-c4127e2a1282"`)

  #{ExDoppler.Doc.resources("integrations", "syncs-create")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  defstruct [:slug, :enabled, :last_synced_at, :project, :config, :integration]

  @doc """
  Creates an `Sync` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **sync**: Map of fields to turn into a `Sync`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.Sync{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = sync), do: struct(ExDoppler.Sync, prepare_keys(sync))
end
