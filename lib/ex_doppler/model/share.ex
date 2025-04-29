defmodule ExDoppler.Share do
  @moduledoc """
  Module describing a [Doppler Share Link](https://docs.doppler.com/reference/share-secret)

  ### Fields
    * `url` - URL to give to the recipient
    * `authenticated_url` - URL which includes the password (so the user doesn't have to type it in)
    * `password` - Password to open the secret
  """
  import ExDoppler.Model

  defstruct [:url, :authenticated_url, :password]

  @doc """
  Creates an `Share` from a map

  ## Params
    * **token**: Map of fields to turn into a `Share`
  """
  def build(%{} = token), do: struct(ExDoppler.Share, prepare_keys(token))
end
