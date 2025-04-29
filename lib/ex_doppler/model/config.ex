defmodule ExDoppler.Config do
  @moduledoc """
  Module describing a [Doppler Config](https://docs.doppler.com/reference/configs-object)

  ### Fields
    * `created_at` - Date and time of the Config's creation (e.g `"2025-04-28T16:09:17.737Z"`)
    * `environment` - Identifier of the environment that the config belongs to (e.g `"dev"`)
    * `inheritable` - Whether the config can be inherited from
    * `inheriting` - Whether the config is inheriting from another
    * `inherits` - List of configs that the config is inheriting from
    * `initial_fetch_at` - Date and time of the first secrets fetch (e.g `"2025-04-28T16:09:17.737Z"`)
    * `last_fetch_at` - Date and time of the last secrets fetch (e.g `"2025-04-28T16:09:17.737Z"`)
    * `locked` - Whether the config can be renamed and/or deleted.
    * `name` - Name of the config (e.g `"dev_personal"`)
    * `project` - Identifier of the project that the config belongs to (e.g `"example-project"`)
    * `root` - Whether the config is the root of the environment.
    * `slug` - Unique identifier for this config (e.g `"00000000-0000-0000-0000-000000000000"`)
  """

  import ExDoppler.Model

  defstruct [
    :created_at,
    :environment,
    :inheritable,
    :inheriting,
    :inherits,
    :initial_fetch_at,
    :last_fetch_at,
    :locked,
    :name,
    :project,
    :root,
    :slug
  ]

  @doc """
  Creates an `Config` from a map

  ### Params
    * **config**: Map of fields to turn into a `Config`
  """
  def build(%{} = config), do: struct(ExDoppler.Config, prepare_keys(config))
end
