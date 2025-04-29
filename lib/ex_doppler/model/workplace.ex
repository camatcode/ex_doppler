defmodule ExDoppler.Workplace do
  @moduledoc """
  Module describing a [Doppler Workplace](https://docs.doppler.com/reference/workplace-object)

  ### Fields
    * `billing_email` - Email to send billing invoices to.
    * `name` - Name of the workplace
    * `security_email` - Email to send security notices to.
    * `id` - Unique ID for the Workplace(e.g `"bc391a7dba8924cd9b69"`)
  """
  defstruct [:billing_email, :name, :security_email, :id]
  import ExDoppler.Model

  @doc """
  Creates a `Workplace` from a map

  ## Params
    * **wp**: Map of fields to turn into a `Workplace`
  """
  def build(%{} = wp), do: struct(ExDoppler.Workplace, prepare_keys(wp))
end
