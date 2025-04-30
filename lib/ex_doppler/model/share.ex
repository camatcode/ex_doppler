# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Share do
  @moduledoc """
  Module describing a Share Link

  <!-- tabs-open -->
  ### Fields
    * `url` - URL to give to the recipient
    * `authenticated_url` - URL which includes the password (so the user doesn't have to type it in)
    * `password` - Password to open the secret

  #{ExDoppler.Doc.resources("share-security", "share-secret")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  defstruct [:url, :authenticated_url, :password]

  @doc """
  Creates an `Share` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **token**: Map of fields to turn into a `Share`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.Share{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = token), do: struct(ExDoppler.Share, prepare_keys(token))
end
