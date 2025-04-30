# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.WorkplaceRole do
  @moduledoc """
  Module describing a WorkplaceRole

  <!-- tabs-open -->
  ### Fields
    * `created_at` - Creation Date and Time (e.g `~U[2025-04-30 10:05:50.040Z]`)
    * `identifier` - ID of the role (e.g `"admin"`)
    * `is_custom_role` - Whether role is custom (e.g `false`)
    * `is_inline_role` - Whether role is inline (e.g `false`)
    * `name` - Human readable name (e.g `"Admin"`)
    * `permissions` - see `all_permissions/0`

  #{ExDoppler.Doc.resources("custom-roles", "workplace_roles-list")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  defstruct [:created_at, :identifier, :is_custom_role, :is_inline_role, :name, :permissions]

  @doc """
  Returns a list of all possible Workplace Role permissions
  """
  def all_permissions,
    do: [
      :all_enclave_projects_admin,
      :all_enclave_projects,
      :billing_manage,
      :billing,
      :create_enclave_project,
      :custom_roles_manage,
      :ekm,
      :enclave_secrets_referencing,
      :logs_audit,
      :logs,
      :service_account_api_tokens_manage,
      :service_account_api_tokens,
      :service_accounts_manage,
      :service_accounts,
      :settings_manage,
      :settings,
      :team_manage,
      :team,
      :verified_domains_manage,
      :verified_domains,
      :workplace_default_environments_manage,
      :workplace_default_environments_read,
      :workplace_integrations_list,
      :workplace_integrations_manage,
      :workplace_integrations_read
    ]

  @doc """
  Creates a `WorkplaceRole` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **wp_role**: Map of fields to turn into a `WorkplaceRole`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.WorkplaceRole{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = wp_role), do: struct(ExDoppler.WorkplaceRole, prepare(wp_role))
end
