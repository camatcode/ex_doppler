defmodule ExDoppler.ServiceAccount do
  @moduledoc """
  Module describing a [Doppler Service Account](https://docs.doppler.com/reference/service_accounts-list){:target="_blank"}

  <!-- tabs-open -->
  ### Fields
    * `name` - Name of the Service Account (e.g `"sa"`)
    * `slug` - Unique slug for this Service Account (e.g `"00000000-0000-0000-0000-000000000000"`)
    * `created_at` - Date and Time for this Service Account's creation (e.g `"2023-08-01T00:00:00.000Z"`)
    * `workplace_role` - See `ExDoppler.WorkplaceRole`

  ### Resources
    * See: `ExDoppler.ServiceAccounts`
    * See: [Doppler API docs](https://docs.doppler.com/reference/service_accounts-list){:target="_blank"}
    * Contact the maintainer (he's happy to help!)
      * [Github](https://github.com/camatcode/){:target="_blank"}
      * [Fediverse: @scrum_log@maston.social](https://mastodon.social/@scrum_log){:target="_blank"}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  alias ExDoppler.WorkplaceRole

  defstruct [:name, :slug, :created_at, :workplace_role]

  @doc """
  Creates an `ServiceAccount` from a map

  <!-- tabs-open -->
  ### Params
    * **account**: Map of fields to turn into a `ServiceAccount`

  <!-- tabs-close -->
  """
  def build(%{} = account) do
    fields =
      account
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ServiceAccount, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:workplace_role, val), do: WorkplaceRole.build(val)
  defp serialize(_, val), do: val
end
