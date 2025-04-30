# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.TokenInfo do
  @moduledoc """
  Module describing a [Doppler Me](https://docs.doppler.com/reference/auth-me){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `slug` - Unique identifier for this token (e.g `"00000000-0000-0000-0000-000000000000"`)
    * `name` - If given, a human-readable name for this token (e.g `"my-auth-token"`)
    * `created_at` - DateTime creation for this token (e.g `"2025-04-24T15:53:27.189Z"`)
    * `last_seen_at` - DateTime for last use (e.g `"2025-04-28T22:05:38.952Z"`)
    * `type` - Token Type (e.g `"personal"`)
    * `token_preview` - Used when referring to this token (e.g `dp.pt....ABCdEF`)
    * `workplace` - Relevant `ExDoppler.Workplace`.

  #{ExDoppler.Doc.resources("service-account-identities", "auth-me")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  alias ExDoppler.Workplace

  defstruct [:slug, :name, :created_at, :last_seen_at, :type, :token_preview, :workplace]

  @doc """
  Creates a `TokenInfo` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **token_info**: Map of fields to turn into a `TokenInfo`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.TokenInfo{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = token_info) do
    fields =
      token_info
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.TokenInfo, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:workplace, val), do: Workplace.build(val)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.ODICToken do
  @moduledoc """
  Module describing a [Doppler ODIC](https://docs.doppler.com/reference/auth-oidc){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `token` - ODIC Token
    * `created_at` - DateTime creation for this token (e.g `"2025-04-24T15:53:27.189Z"`)

  #{ExDoppler.Doc.resources("service-account-identities", "auth-me")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  defstruct [:token, :expires_at]

  @doc """
  Creates a `ODICToken` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **odic_token**: Map of fields to turn into a `ODICToken`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.ODICToken{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = odic_token), do: struct(ExDoppler.ODICToken, prepare_keys(odic_token))
end
