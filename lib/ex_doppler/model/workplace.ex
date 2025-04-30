# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Workplace do
  @moduledoc """
  Module describing a Workplace

  <!-- tabs-open -->
  ### Fields
    * `billing_email` - Email to send billing invoices to.
    * `name` - Name of the workplace
    * `security_email` - Email to send security notices to.
    * `id` - Unique ID for the Workplace(e.g `"bc391a7dba8924cd9b69"`)

  #{ExDoppler.Doc.resources("workplace-structure", "workplace-object")}

  <!-- tabs-close -->
  """
  defstruct [:billing_email, :name, :security_email, :id]
  import ExDoppler.Model

  @doc """
  Creates a `Workplace` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **wp**: Map of fields to turn into a `Workplace`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.Workplace{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = wp), do: struct(ExDoppler.Workplace, prepare(wp))
end
