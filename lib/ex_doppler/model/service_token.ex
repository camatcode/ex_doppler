# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ServiceToken do
  @moduledoc """
  Module describing a Service Token

  <!-- tabs-open -->
  ### Fields
    * `name` - Name of the service token. (e.g `"AWS Lambda"`)
    * `slug` - Unique slug for this token (e.g `"00000000-0000-0000-0000-000000000000"`)
    * `created_at` - Date and Time for this token's creation (e.g `~U[2025-04-30 10:05:50.040Z]`)
    * `config` - Config associated with the token (e.g `"prd_aws"`)
    * `environment` - Environment associated with the token (e.g `"prd"`)
    * `expires_at` - Date and Time this token will expire (e.g `~U[2025-04-30 10:05:50.040Z]`)

  #{ExDoppler.Doc.resources("service-tokens", "service_tokens-list")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  defstruct [:name, :slug, :created_at, :config, :environment, :project, :expires_at]

  @doc """
  Creates an `ServiceToken` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **token**: Map of fields to turn into a `ServiceToken`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.ServiceToken{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = token), do: struct(ExDoppler.ServiceToken, prepare(token))
end
