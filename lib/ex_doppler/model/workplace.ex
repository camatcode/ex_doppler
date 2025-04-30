defmodule ExDoppler.Workplace do
  @moduledoc """
  Module describing a [Doppler Workplace](https://docs.doppler.com/reference/workplace-object){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `billing_email` - Email to send billing invoices to.
    * `name` - Name of the workplace
    * `security_email` - Email to send security notices to.
    * `id` - Unique ID for the Workplace(e.g `"bc391a7dba8924cd9b69"`)

  ### Help
    * See: `ExDoppler.Workplaces`
    * See: [Doppler API docs](https://docs.doppler.com/reference/workplace-object){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """
  defstruct [:billing_email, :name, :security_email, :id]
  import ExDoppler.Model

  @doc """
  Creates a `Workplace` from a map

  <!-- tabs-open -->
  ### Params
    * **wp**: Map of fields to turn into a `Workplace`

  <!-- tabs-close -->
  """
  def build(%{} = wp), do: struct(ExDoppler.Workplace, prepare_keys(wp))
end
