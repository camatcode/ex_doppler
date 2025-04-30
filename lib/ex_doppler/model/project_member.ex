# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ProjectMember do
  @moduledoc """
  Module describing a ProjectMember

  <!-- tabs-open -->
  ### Fields
    * `access_all_environments` - Whether the member can see all environments (e.g `true`)
    * `environments` - List of environments relevant to the member (e.g `["dev", "prd"]`).
    * `role` - See `ExDoppler.ProjectMemberRole`
    * `slug` - Unique identifier for project member (e.g `"e32d0dcd-c094-4606-aefa-c4127e2a1282"`)
    * `type` - member type (e.g `"workplace_user"`)

  #{ExDoppler.Doc.resources("project-permissions#by-project", "project_members-list")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  alias ExDoppler.ProjectMemberRole

  defstruct [:access_all_environments, :environments, :role, :slug, :type]

  @doc """
  Creates an `ProjectMember` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **member**: Map of fields to turn into a `ProjectMember`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.ProjectMember{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = member) do
    fields =
      member
      |> prepare()
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
  Module describing a ProjectMemberRole

  <!-- tabs-open -->
  ### Fields
    * `identifier` - e.g `"collaborator"` or `"admin"` or `"viewer"` or `"no_access"`

  #{ExDoppler.Doc.resources("project-permissions#by-project", "project_members-list")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  defstruct [:identifier]

  @doc """
  Creates an `ProjectMemberRole` from a map


  <!-- tabs-open -->
  ### 🏷️ Params
    * **role**: Map of fields to turn into a `ProjectMemberRole`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.ProjectMemberRole{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = role), do: struct(ExDoppler.ProjectMemberRole, prepare(role))
end
