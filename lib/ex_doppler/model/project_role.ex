# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ProjectRole do
  @moduledoc """
  Module describing a [Doppler Project Role](https://docs.doppler.com/reference/project_roles-list){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `created_at` - Date and Time the role was created (e.g `~U[2025-04-30 10:05:50.040Z]`)
    * `identifier` - List of environments relevant to the member (e.g `["dev", "prd"]`).
    * `is_custom_role` - Whether it's a user made role (e.g `false`)
    * `name` - Name of role (e.g `"viewer"`)
    * `permissions` - member type (e.g `["enclave_config_logs", "enclave_project_config_secrets_read"...]`)

  #{ExDoppler.Doc.resources("project-permissions", "project_roles-list")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  defstruct [:created_at, :identifier, :is_custom_role, :name, :permissions]

  @doc """
  Creates an `ProjectRole` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **role**: Map of fields to turn into a `ProjectRole`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.ProjectRole{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = role), do: struct(ExDoppler.ProjectRole, prepare(role))
end
