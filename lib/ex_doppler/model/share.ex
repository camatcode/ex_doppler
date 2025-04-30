defmodule ExDoppler.Share do
  @moduledoc """
  Module describing a [Doppler Share Link](https://docs.doppler.com/reference/share-secret){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `url` - URL to give to the recipient
    * `authenticated_url` - URL which includes the password (so the user doesn't have to type it in)
    * `password` - Password to open the secret

  ### Resources
    * See: `ExDoppler.Shares`
    * See: [Doppler API docs](https://docs.doppler.com/reference/share-secret){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  defstruct [:url, :authenticated_url, :password]

  @doc """
  Creates an `Share` from a map

  <!-- tabs-open -->
  ### Params
    * **token**: Map of fields to turn into a `Share`

  <!-- tabs-close -->
  """
  def build(%{} = token), do: struct(ExDoppler.Share, prepare_keys(token))
end
