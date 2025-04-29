defmodule ExDoppler.ProjectMember do
  @moduledoc """
  Module describing a [Doppler Project Member](https://docs.doppler.com/reference/project_members-list)

  ### Fields
    * `access_all_environments` - Whether the member can see all environments
    * `environments` - List of environments relevant to the member (e.g `["dev", "prd"]`).
    * `role` - See `ExDoppler.ProjectMemberRole`
    * `slug` - Unique identifier for project member (e.g `"e32d0dcd-c094-4606-aefa-c4127e2a1282"`)
    * `type` - member type (e.g `"workplace_user"`)
  """
  import ExDoppler.Model

  alias ExDoppler.ProjectMemberRole

  defstruct [:access_all_environments, :environments, :role, :slug, :type]

  @doc """
  Creates an `ProjectMember` from a map

  ### Params
    * **member**: Map of fields to turn into a `ProjectMember`
  """
  def build(%{} = member) do
    fields =
      member
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ProjectMember, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:role, val), do: ProjectMemberRole.build(val)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.ProjectMemberRole do
  @moduledoc """
  Module describing a [Doppler Project Member Role](https://docs.doppler.com/reference/project_members-list)

  ### Fields
    * `identifier` - e.g `"collaborator"` or `"admin"` or `"viewer"` or `"no_access"`
  """
  import ExDoppler.Model

  defstruct [:identifier]

  @doc """
  Creates an `ProjectMemberRole` from a map

  ### Params
    * **role**: Map of fields to turn into a `ProjectMemberRole`
  """
  def build(%{} = role), do: struct(ExDoppler.ProjectMemberRole, prepare_keys(role))
end
