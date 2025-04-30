defmodule ExDoppler.Project do
  @moduledoc """
  Module describing a [Doppler Project](https://docs.doppler.com/reference/projects-object){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `created_at` - Date and Time of Project creation (e.g `"2025-04-28T16:09:17.737Z"`)
    * `description` - Optional description for Project (e.g `"my awesome project"`)
    * `id` - Unique identifier for the object (e.g `"jed0c2a68b6"`)
    * `name` - Name of the project (e.g `"example-project"`)
    * `slug` - Slug of project (e.g `"example-project"`)

  ### Help
    * See: `ExDoppler.Projects`
    * See: [Doppler API docs](https://docs.doppler.com/reference/projects-object){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  defstruct [:created_at, :description, :id, :name, :slug]

  @doc """
  Creates an `Project` from a map

  <!-- tabs-open -->
  ### Params
    * **project**: Map of fields to turn into a `Project`

  <!-- tabs-close -->
  """
  def build(%{} = project), do: struct(ExDoppler.Project, prepare_keys(project))
end
