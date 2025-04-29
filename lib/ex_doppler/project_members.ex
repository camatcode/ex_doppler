defmodule ExDoppler.ProjectMembers do
  @moduledoc """
  Module for interacting with `ExDoppler.ProjectMember`
  """

  alias ExDoppler.Project
  alias ExDoppler.ProjectMember
  alias ExDoppler.Util.Requester

  @project_members_api_path "/v3/projects/project/members"

  @doc """
  Lists `ExDoppler.ProjectMember` using pagination

  *Returns* `{:ok, [%ExDoppler.ProjectMember{}...]}` or `{:err, err}`

  ## Params
    * **project**: The `ExDoppler.Project` for which you want the environments (e.g `%Project{name: "example-project"}`)
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **per_page** - the number of `ExDoppler.ProjectMember` to return for this page (e.g `per_page: 50`). Default: `20`

  See [Doppler Docs](https://docs.doppler.com/reference/project_members-list)
  """
  def list_project_members(%Project{slug: project_slug}, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_slug], opts)

    with {:ok, %{body: body}} <- Requester.get(@project_members_api_path, qparams: opts) do
      members =
        body["members"]
        |> Enum.map(&ProjectMember.build/1)

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
  Retrieves a `ExDoppler.ProjectMember`, given a project, a member type and slug

  *Returns* `{:ok, %ExDoppler.ProjectMember{...}}` or `{:err, err}`

  ## Params
    * **project**: The `ExDoppler.Project` for which you want the environments (e.g `%Project{name: "example-project"}`)
    * **member_type**: type of member (e.g `"workplace_user"`)
    * **member_slug**: slug of member (e.g `"e32d0dcd-c094-4606-aefa-c4127e2a1282"`)

  See [Doppler Docs](https://docs.doppler.com/reference/project_members-get)
  """
  def get_project_member(%Project{slug: project_slug}, member_type, member_slug)
      when is_bitstring(member_type) and is_bitstring(member_slug) do
    path =
      @project_members_api_path
      |> Path.join("/member/#{member_type}/#{member_slug}")

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
