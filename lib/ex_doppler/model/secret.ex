defmodule ExDoppler.Secret do
  @moduledoc """
  Module describing a [Doppler Secret](https://docs.doppler.com/reference/secrets-list){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `name` - Name of the Secret (e.g `"API_KEY"`)
    * `raw` - Raw value of the Secret
    * `computed` - Computed value of the Secret
    * `note` - A descriptive note to the Secret
    * `raw_visibility` - Raw visibility. `:masked`, `:unmasked`, or `:restricted`
    * `computed_visibility` - Computed visibility. `:masked`, `:unmasked`, or `:restricted`

  ### Resources
    * See: `ExDoppler.Secrets`
    * See: [Doppler API docs](https://docs.doppler.com/reference/secrets-list){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  defstruct [:name, :raw, :computed, :note, :raw_visibility, :computed_visibility]

  @doc """
  Creates an `Secret` from a map

  <!-- tabs-open -->
  ### Params
    * **{name, map}**: The secret's name and map of fields to turn into a `Secret`

  <!-- tabs-close -->
  """
  def build({name, map}) do
    fields =
      Map.put(map, "name", name)
      |> prepare_keys()

    struct(ExDoppler.Secret, fields)
  end
end
