defmodule ExDoppler.Projects do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def projects_api_path, do: "/v3/projects"

  def list_projects(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    projects_api_path()
    |> Requester.get(qparams: [page: opts[:page], per_page: opts[:per_page]])
    |> case do
      {:ok, %{body: body}} ->
        page = body["page"]

        projects =
          body["projects"]
          |> Enum.map(&build_project/1)

        {:ok, %{page: page, projects: projects}}

      err ->
        err
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
