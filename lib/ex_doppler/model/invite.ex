# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Invite do
  @moduledoc """
  Module describing an Invite

  <!-- tabs-open -->
  ### Fields
    * `slug` - Unique identifier for the object  (e.g `"e32d0dcd-c094-4606-aefa-c4127e2a1282"`)
    * `email` - Unique identifier for the object (e.g `"jsmith@example.com"`)
    * `created_at` - Date and Time of Invite (e.g ~U[2025-04-30 10:05:50.040Z])
    * `workplace_role` - See `ExDoppler.WorkplaceRole`

  #{ExDoppler.Doc.resources("workplace-team#send-invite", "invites-list")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  alias ExDoppler.WorkplaceRole

  defstruct [:slug, :email, :created_at, :workplace_role]

  @doc """
  Creates an `Invite` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **invite**: Map of fields to turn into a `Invite`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.Invite{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = invite) do
    fields =
      invite
      |> prepare()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Invite, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:workplace_role, val), do: WorkplaceRole.build(val)
  defp serialize(_, val), do: val
end
