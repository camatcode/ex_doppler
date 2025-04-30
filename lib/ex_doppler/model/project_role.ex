defmodule ExDoppler.ProjectRole do
  @moduledoc """
  Module describing a [Doppler Project Role](https://docs.doppler.com/reference/project_roles-list){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `created_at` - Date and Time the role was created (e.g `"2025-04-28T16:09:17.737Z"`)
    * `identifier` - List of environments relevant to the member (e.g `["dev", "prd"]`).
    * `is_custom_role` - Whether it's a user made role (e.g `false`)
    * `name` - Name of role (e.g `"viewer"`)
    * `permissions` - member type (e.g `["enclave_config_logs", "enclave_project_config_secrets_read"...]`)

  ### Help
    * See: `ExDoppler.ProjectRoles`
    * See: [Doppler API docs](https://docs.doppler.com/reference/project_roles-list){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  defstruct [:created_at, :identifier, :is_custom_role, :name, :permissions]

  @doc """
  Creates an `ProjectRole` from a map

  <!-- tabs-open -->
  ### Params
    * **role**: Map of fields to turn into a `ProjectRole`

  <!-- tabs-close -->
  """
  def build(%{} = role), do: struct(ExDoppler.ProjectRole, prepare_keys(role))
end
