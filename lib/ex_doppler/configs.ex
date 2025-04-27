defmodule ExDoppler.Configs do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @configs_api_path "/v3/configs"

  def list_configs(project_name, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@configs_api_path, qparams: opts) do
      page = body["page"]

      configs =
        body["configs"]
        |> Enum.map(&build_config/1)

      {:ok, %{page: page, configs: configs}}
    end
  end

  def get_config(project_name, config_name)
      when is_bitstring(project_name) and is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config")

    with {:ok, %{body: body}} <-
           Requester.get(path, qparams: [project: project_name, config: config_name]) do
      {:ok, build_config(body["config"])}
    end
  end

  def create_config(project_name, environment_id, config_name)
      when is_bitstring(project_name) and
             is_bitstring(environment_id) and
             is_bitstring(config_name) do
    body = %{project: project_name, environment: environment_id, name: config_name}

    with {:ok, %{body: body}} <- Requester.post(@configs_api_path, json: body) do
      {:ok, build_config(body["config"])}
    end
  end

  def delete_config(project_name, config_name)
      when is_bitstring(project_name) and
             is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config")

    opts = [qparams: [project: project_name, config: config_name]]

    with {:ok, %{body: body}} <- Requester.delete(path, opts) do
      {:ok, {:success, body["success"]}}
    end
  end

  def list_trusted_ips(project_name, config_name)
      when is_bitstring(project_name) and is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config/trusted_ips")

    with {:ok, %{body: body}} <-
           Requester.get(path, qparams: [project: project_name, config: config_name]) do
      {:ok, body["ips"]}
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
