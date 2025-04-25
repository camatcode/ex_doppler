defmodule ExDoppler.Configs do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def configs_api_path, do: "/v3/configs"

  def list_configs(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: nil], opts)

    configs_api_path()
    |> Requester.get(qparams: opts)
    |> case do
      {:ok, %{body: body}} ->
        page = body["page"]

        configs =
          body["configs"]
          |> Enum.map(&build_config/1)

        {:ok, %{page: page, configs: configs}}

      err ->
        err
    end
  end

  def get_config(project_name, config_name) do
    configs_api_path()
    |> Path.join("/config")
    |> Requester.get(qparams: [project: project_name, config: config_name])
    |> case do
      {:ok, %{body: body}} ->
        {:ok, build_config(body["config"])}

      err ->
        err
    end
  end

  def list_trusted_ips(project_name, config_name) do
    configs_api_path()
    |> Path.join("/config/trusted_ips")
    |> Requester.get(qparams: [project: project_name, config: config_name])
    |> case do
      {:ok, %{body: body}} ->
        {:ok, body["ips"]}

      err ->
        err
    end
  end

  defp build_config(config) do
    fields =
      config
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.Config, fields)
  end
end
