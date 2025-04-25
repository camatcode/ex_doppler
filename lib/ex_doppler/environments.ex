defmodule ExDoppler.Environments do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def environments_api_path, do: "/v3/environments"

  def list_environments(project_name, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    environments_api_path()
    |> Requester.get(
      qparams: [project: project_name, per_page: opts[:per_page], page: opts[:page]]
    )
    |> case do
      {:ok, %{body: body}} ->
        page = body["page"]

        environments =
          body["environments"]
          |> Enum.map(&build_environment/1)

        {:ok, %{page: page, environments: environments}}

      err ->
        err
    end
  end

  def get_environment(project_name, environment_slug) do
    environments_api_path()
    |> Path.join("/environment")
    |> Requester.get(qparams: [project: project_name, environment: environment_slug])
    |> case do
      {:ok, %{body: body}} ->
        {:ok, build_environment(body["environment"])}

      err ->
        err
    end
  end

  defp build_environment(env) do
    fields =
      env
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.Environment, fields)
  end
end
