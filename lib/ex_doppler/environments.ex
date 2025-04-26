defmodule ExDoppler.Environments do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @environments_api_path "/v3/environments"

  def list_environments(project_name, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@environments_api_path, qparams: opts) do
      page = body["page"]

      environments =
        body["environments"]
        |> Enum.map(&build_environment/1)

      {:ok, %{page: page, environments: environments}}
    end
  end

  def get_environment(project_name, environment_slug) do
    path =
      @environments_api_path
      |> Path.join("/environment")

    with {:ok, %{body: body}} <-
           Requester.get(qparams: [project: project_name, environment: environment_slug]) do
      {:ok, build_environment(body["environment"])}
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
