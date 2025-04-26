defmodule ExDoppler.Projects do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @projects_api_path "/v3/projects"

  def list_projects(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@projects_api_path, qparams: opts) do
      page = body["page"]

      projects =
        body["projects"]
        |> Enum.map(&build_project/1)

      {:ok, %{page: page, projects: projects}}
    end
  end

  def get_project(identifier) when not is_nil(identifier) do
    path =
      @projects_api_path
      |> Path.join("/project")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [project: identifier]) do
      {:ok, build_project(body["project"])}
    end
  end

  def list_project_permissions() do
    path =
      @projects_api_path
      |> Path.join("/permissions")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, body["permissions"]}
    end
  end

  defp build_project(project) do
    fields =
      project
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.Project, fields)
  end
end
