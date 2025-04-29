defmodule ExDoppler.ServiceToken do
  @moduledoc """
  Module describing a [Doppler Service Token](https://docs.doppler.com/reference/service_tokens-object)

  ### Fields
    * `name` - Name of the service token. (e.g `"AWS Lambda"`)
    * `slug` - Unique slug for this token (e.g `"00000000-0000-0000-0000-000000000000"`)
    * `created_at` - Date and Time for this token's creation (e.g `"2023-08-01T00:00:00.000Z"`)
    * `config` - Config associated with the token (e.g `"prd_aws"`)
    * `environment` - Environment associated with the token (e.g `"prd"`)
    * `expires_at` - Date and Time this token will expire (e.g `"2023-08-01T00:00:00.000Z"`)
  """
  import ExDoppler.Model

  defstruct [:name, :slug, :created_at, :config, :environment, :project, :expires_at]

  @doc """
  Creates an `ServiceToken` from a map

  ## Params
    * **token**: Map of fields to turn into a `ServiceToken`
  """
  def build(%{} = token), do: struct(ExDoppler.ServiceToken, prepare_keys(token))
end
