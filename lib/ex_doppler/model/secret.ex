defmodule ExDoppler.Secret do
  @moduledoc """
  Module describing a [Doppler Secret](https://docs.doppler.com/reference/secrets-list)

  ### Fields
    * `name` - Name of the Secret (e.g `"API_KEY"`)
    * `raw` - Raw value of the Secret
    * `computed` - Computed value of the Secret
    * `note` - A descriptive note to the Secret
    * `raw_visibility` - Raw visibility. `:masked`, `:unmasked`, or `:restricted`
    * `computed_visibility` - Computed visibility. `:masked`, `:unmasked`, or `:restricted`
  """

  import ExDoppler.Model

  defstruct [:name, :raw, :computed, :note, :raw_visibility, :computed_visibility]

  @doc """
  Creates an `Secret` from a map

  ## Params
    * **{name, map}**: The secret's name and map of fields to turn into a `Secret`
  """
  def build({name, map}) do
    fields =
      Map.put(map, "name", name)
      |> prepare_keys()

    struct(ExDoppler.Secret, fields)
  end
end
