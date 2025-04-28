defmodule ExDoppler.Environments do
  @moduledoc false

  alias ExDoppler.Environment
  alias ExDoppler.Project
  alias ExDoppler.Util.Requester

  @environments_api_path "/v3/environments"

  def list_environments(%Project{name: project_name}, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@environments_api_path, qparams: opts) do
      page = body["page"]

      environments =
        body["environments"]
        |> Enum.map(&Environment.build/1)

      {:ok, %{page: page, environments: environments}}
    end
  end

  def list_environments!(%Project{} = project, opts \\ []) do
    with {:ok, environments} <- list_environments(project, opts) do
      environments
    end
  end

  def get_environment(%Project{name: project_name}, environment_slug)
      when is_bitstring(environment_slug) do
    path =
      @environments_api_path
      |> Path.join("/environment")

    opts = [qparams: [project: project_name, environment: environment_slug]]

    with {:ok, %{body: body}} <- Requester.get(path, opts) do
      {:ok, Environment.build(body["environment"])}
    end
  end

  def get_environment!(%Project{} = project, environment_slug) do
    with {:ok, environment} <- get_environment(project, environment_slug) do
      environment
    end
  end

  def create_environment(
        %Project{name: project_name},
        env_name,
        env_slug,
        enable_personal_config \\ false
      )
      when is_bitstring(env_name) and is_bitstring(env_slug) and
             is_boolean(enable_personal_config) do
    body = %{name: env_name, slug: env_slug, personal_configs: enable_personal_config}
    opts = [qparams: [project: project_name], json: body]

    with {:ok, %{body: body}} <- Requester.post(@environments_api_path, opts) do
      {:ok, Environment.build(body["environment"])}
    end
  end

  def create_environment!(
        %Project{} = project,
        env_name,
        env_slug,
        enable_personal_config \\ false
      ) do
    with {:ok, environment} <-
           create_environment(project, env_name, env_slug, enable_personal_config) do
      environment
    end
  end

  def update_environment(%Environment{project: project_name, slug: env_slug}, opts \\ []) do
    with {:ok, environment} <- get_environment(%Project{name: project_name}, env_slug) do
      path =
        @environments_api_path
        |> Path.join("/environment")

      opts =
        Keyword.merge(
          [name: environment.name, slug: environment.slug, personal_configs: nil],
          opts
        )

      body =
        %{name: opts[:name], slug: opts[:slug], personal_configs: opts[:personal_configs]}
        |> Enum.filter(fn {_k, v} -> v end)
        |> Enum.into(%{})

      qparams = [project: project_name, environment: env_slug]

      with {:ok, %{body: body}} <- Requester.put(path, qparams: qparams, json: body) do
        {:ok, Environment.build(body["environment"])}
      end
    end
  end

  def update_environment!(%Environment{} = environment, opts \\ []) do
    with {:ok, environment} <- update_environment(environment, opts) do
      environment
    end
  end

  def delete_environment(%Environment{project: project_name, slug: env_slug}) do
    opts = [qparams: [project: project_name, environment: env_slug]]

    path =
      @environments_api_path
      |> Path.join("/environment")

    with {:ok, %{body: body}} <- Requester.delete(path, opts) do
      {:ok, {:success, body["success"]}}
    end
  end

  def delete_environment!(%Environment{} = environment) do
    with {:ok, _} <- delete_environment(environment) do
      :ok
    end
  end
end
