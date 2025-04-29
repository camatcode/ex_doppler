defmodule ExDoppler.Project do
  @moduledoc """
  Module describing a [Doppler Project](https://docs.doppler.com/reference/projects-object)

  ### Fields
    * `created_at` - Date and Time of Project creation (e.g `"2025-04-28T16:09:17.737Z"`)
    * `description` - Optional description for Project (e.g `"my awesome project"`)
    * `id` - Unique identifier for the object (e.g `"jed0c2a68b6"`)
    * `name` - Name of the project (e.g `"example-project"`)
    * `slug` - Slug of project (e.g `"example-project"`)
  """
  import ExDoppler.Model

  defstruct [:created_at, :description, :id, :name, :slug]

  @doc """
  Creates an `Project` from a map

  ## Params
    * **project**: Map of fields to turn into a `Project`
  """
  def build(%{} = project), do: struct(ExDoppler.Project, prepare_keys(project))
end
