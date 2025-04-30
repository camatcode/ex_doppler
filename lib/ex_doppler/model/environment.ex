# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Environment do
  @moduledoc """
  Module describing an Environment

  <!-- tabs-open -->
  ### Fields
    * `created_at` - Date and time of environment's creation (e.g `"2025-04-28T16:09:17.737Z"`)
    * `id` - Unique identifier for the object (e.g `"eot"`)
    * `initial_fetch_at` - Date and time of the first secrets fetch from a config in the environment (e.g `"2025-04-28T16:09:17.737Z"`)
    * `name` - Name of the environment.
    * `project` - Unique identifier for the project object (e.g `"example-project"`)
    * `slug` - Unique identifier for the object (e.g `"eot"`)

  #{ExDoppler.Doc.resources("create-project#environments", "environments-object")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model
  defstruct [:created_at, :id, :initial_fetch_at, :name, :project, :slug]

  @doc """
  Creates an `Environment` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **env**: Map of fields to turn into a `Environment`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.Environment{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = env), do: struct(ExDoppler.Environment, prepare_keys(env))
end
