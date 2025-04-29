defmodule ExDoppler.Invite do
  @moduledoc """
  Module describing a [Doppler Invite](https://docs.doppler.com/reference/invites-list)

  ### Fields
    * `slug` - Unique identifier for the object  (e.g `"e32d0dcd-c094-4606-aefa-c4127e2a1282"`)
    * `email` - Unique identifier for the object (e.g `"jsmith@example.com"`)
    * `created_at` - Date and Time of Invite (e.g `"2025-04-28T16:09:17.737Z"`)
    * `workplace_role` - See `ExDoppler.WorkplaceRole`
  """

  import ExDoppler.Model

  alias ExDoppler.WorkplaceRole

  defstruct [:slug, :email, :created_at, :workplace_role]

  @doc """
  Creates an `Invite` from a map

  ### Params
    * **invite**: Map of fields to turn into a `Invite`
  """
  def build(%{} = invite) do
    fields =
      invite
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Invite, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:workplace_role, val), do: WorkplaceRole.build(val)
  defp serialize(_, val), do: val
end
