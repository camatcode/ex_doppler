defmodule ExDoppler.ProjectMembers do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def project_members_api_path, do: "/v3/projects/project/members"

  def list_project_members(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    project_members_api_path()
    |> Requester.get(qparams: [page: opts[:page], per_page: opts[:per_page]])
    |> case do
      {:ok, %{body: body}} ->
        members =
          body["members"]
          |> Enum.map(&build_project_member/1)

        {:ok, members}

      err ->
        err
    end
  end

  def get_project_member(member_type, member_slug) do
    project_members_api_path()
    |> Path.join("/member/#{member_type}/#{member_slug}")
    |> Requester.get()
    |> case do
      {:ok, %{body: body}} ->
        {:ok, build_project_member(body["member"])}

      err ->
        err
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

  defp serialize(_, nil), do: nil

  defp serialize(:role, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.ProjectMemberRole, val)
  end

  defp serialize(_, val), do: val
end
