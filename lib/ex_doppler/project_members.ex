defmodule ExDoppler.ProjectMembers do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @project_members_api_path "/v3/projects/project/members"

  def list_project_members(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@project_members_api_path, qparams: opts) do
      members =
        body["members"]
        |> Enum.map(&build_project_member/1)

      {:ok, members}
    end
  end

  def get_project_member(member_type, member_slug)
      when not is_nil(member_type) and not is_nil(member_slug) do
    path =
      @project_members_api_path
      |> Path.join("/member/#{member_type}/#{member_slug}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, build_project_member(body["member"])}
    end
  end

  defp build_project_member(member) do
    fields =
      member
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ProjectMember, fields)
  end

  defp serialize(:role, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.ProjectMemberRole, val)
  end

  defp serialize(_, val), do: val
end
