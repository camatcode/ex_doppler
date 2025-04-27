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

  def get_project(identifier) when is_bitstring(identifier) do
    path =
      @projects_api_path
      |> Path.join("/project")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: [project: identifier]) do
      {:ok, build_project(body["project"])}
    end
  end

  def create_project(project_name, description \\ "")
      when is_bitstring(project_name) and is_bitstring(description) do
    body =
      %{name: project_name, description: description}
      |> Enum.filter(fn {_k, v} -> v end)
      |> Enum.into(%{})

    with {:ok, %{body: body}} <- Requester.post(@projects_api_path, json: body) do
      {:ok, build_project(body["project"])}
    end
  end

  def update_project(current_project_name, opts \\ []) when is_bitstring(current_project_name) do
    with {:ok, project} <- get_project(current_project_name) do
      opts = Keyword.merge([name: project.name, description: project.description], opts)

      body =
        %{project: project.id, name: opts[:name], description: opts[:description]}
        |> Enum.filter(fn {_k, v} -> v end)
        |> Enum.into(%{})

      path =
        @projects_api_path
        |> Path.join("/project")

      with {:ok, %{body: body}} <- Requester.post(path, json: body) do
        {:ok, build_project(body["project"])}
      end
    end
  end

  def delete_project(project_name) when is_bitstring(project_name) do
    path =
      @projects_api_path
      |> Path.join("/project")

    with {:ok, %{body: body}} <-
           Requester.delete(path, json: %{project: project_name}) do
      {:ok, {:success, body["success"]}}
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
