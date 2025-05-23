# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ProjectMembers do
  @moduledoc """
  Module for interacting with `ExDoppler.ProjectMember`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("project-permissions#by-project", "project_members-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Project
  alias ExDoppler.ProjectMember
  alias ExDoppler.Requester

  @project_members_api_path "/v3/projects/project/members"

  @doc """
  Lists `ExDoppler.ProjectMember` using pagination

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project**: The `ExDoppler.Project` for which you want the environments (e.g `%Project{name: "example-project"}`)
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.ProjectMember` to return for this page (e.g `per_page: 50`). Default: `20`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.ProjectMember{...}]}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.ProjectMembers
      iex> alias ExDoppler.Projects
      iex> [project | _]= Projects.list_projects!()
      iex> {:ok, _members} = ProjectMembers.list_project_members(project, page: 1, per_page: 20)

  #{ExDoppler.Doc.resources("project_members-list")}

  <!-- tabs-close -->
  """
  def list_project_members(%Project{slug: project_slug}, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_slug], opts)

    with {:ok, %{body: body}} <- Requester.get(@project_members_api_path, qparams: opts) do
      members = Enum.map(body["members"], &ProjectMember.build/1)

      {:ok, members}
    end
  end

  @doc """
  Same as `list_project_members/2` but won't wrap a successful response in `{:ok, response}`
  """
  def list_project_members!(%Project{} = project, opts \\ []) do
    with {:ok, project_members} <- list_project_members(project, opts) do
      project_members
    end
  end

  @doc """
  Retrieves a `ExDoppler.ProjectMember`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project**: The `ExDoppler.Project` for which you want the environments (e.g `%Project{name: "example-project"}`)
    * **member_type**: type of member (e.g `"workplace_user"`)
    * **member_slug**: slug of member (e.g `"e32d0dcd-c094-4606-aefa-c4127e2a1282"`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.ProjectMember{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.ProjectMembers
      iex> alias ExDoppler.Projects
      iex> [project | _]= Projects.list_projects!()
      iex> {:ok, [member | _]} = ProjectMembers.list_project_members(project, page: 1, per_page: 20)
      iex> {:ok, _member} = ProjectMembers.get_project_member(project,  member.type, member.slug)

  #{ExDoppler.Doc.resources("project_members-get")}

  <!-- tabs-close -->
  """
  def get_project_member(%Project{slug: project_slug}, member_type, member_slug)
      when is_bitstring(member_type) and is_bitstring(member_slug) do
    path = Path.join(@project_members_api_path, "/member/#{member_type}/#{member_slug}")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [project: project_slug]) do
      {:ok, ProjectMember.build(body["member"])}
    end
  end

  @doc """
  Same as `get_project_member/3` but won't wrap a successful response in `{:ok, response}`
  """
  def get_project_member!(%Project{} = project, member_type, member_slug) do
    with {:ok, project_member} <- get_project_member(project, member_type, member_slug) do
      project_member
    end
  end
end
