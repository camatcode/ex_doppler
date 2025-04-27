defmodule ExDoppler.ProjectMembers do
  @moduledoc false

  alias ExDoppler.ProjectMember
  alias ExDoppler.Util.Requester

  @project_members_api_path "/v3/projects/project/members"

  def list_project_members(project_slug, opts \\ []) when is_bitstring(project_slug) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_slug], opts)

    with {:ok, %{body: body}} <- Requester.get(@project_members_api_path, qparams: opts) do
      members =
        body["members"]
        |> Enum.map(&ProjectMember.build_project_member/1)

      {:ok, members}
    end
  end

  def get_project_member(project_slug, member_type, member_slug)
      when is_bitstring(project_slug) and is_bitstring(member_type) and is_bitstring(member_slug) do
    path =
      @project_members_api_path
      |> Path.join("/member/#{member_type}/#{member_slug}")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [project: project_slug]) do
      {:ok, ProjectMember.build_project_member(body["member"])}
    end
  end
end
