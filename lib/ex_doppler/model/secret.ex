# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Secret do
  @moduledoc """
  Module describing a Secret

  <!-- tabs-open -->
  ### Fields
    * `name` - Name of the Secret (e.g `"API_KEY"`)
    * `raw` - Raw value of the Secret
    * `computed` - Computed value of the Secret
    * `note` - A descriptive note to the Secret
    * `raw_visibility` - Raw visibility. `:masked`, `:unmasked`, or `:restricted`
    * `computed_visibility` - Computed visibility. `:masked`, `:unmasked`, or `:restricted`

  #{ExDoppler.Doc.resources("secrets", "secrets-list")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  defstruct [:name, :raw, :computed, :note, :raw_visibility, :computed_visibility]

  @doc """
  Creates an `Secret` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **{name, map}**: The secret's name and map of fields to turn into a `Secret`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.Secret{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build({name, map}) do
    fields =
      Map.put(map, "name", name)
      |> prepare()

    struct(ExDoppler.Secret, fields)
  end
end
