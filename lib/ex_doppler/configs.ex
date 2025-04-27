defmodule ExDoppler.Configs do
  @moduledoc false

  alias ExDoppler.Config
  alias ExDoppler.Util.Requester

  @configs_api_path "/v3/configs"

  def list_configs(project_name, opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20, project: project_name], opts)

    with {:ok, %{body: body}} <- Requester.get(@configs_api_path, qparams: opts) do
      page = body["page"]

      configs =
        body["configs"]
        |> Enum.map(&Config.build/1)

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
      {:ok, Config.build(body["config"])}
    end
  end

  def create_config(project_name, environment_id, config_name)
      when is_bitstring(project_name) and
             is_bitstring(environment_id) and
             is_bitstring(config_name) do
    body = %{project: project_name, environment: environment_id, name: config_name}

    with {:ok, %{body: body}} <- Requester.post(@configs_api_path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  def rename_config(project_name, current_config_name, new_config_name)
      when is_bitstring(project_name) and
             is_bitstring(current_config_name) and
             is_bitstring(new_config_name) do
    path =
      @configs_api_path
      |> Path.join("/config")

    body = %{project: project_name, config: current_config_name, name: new_config_name}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  def clone_config(project_name, source_config, new_config_name)
      when is_bitstring(project_name) and
             is_bitstring(source_config) and
             is_bitstring(new_config_name) do
    path =
      @configs_api_path
      |> Path.join("/config/clone")

    body = %{project: project_name, config: source_config, name: new_config_name}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  def lock_config(project_name, config_name)
      when is_bitstring(project_name) and
             is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config/lock")

    body = %{project: project_name, config: config_name}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  def unlock_config(project_name, config_name)
      when is_bitstring(project_name) and
             is_bitstring(config_name) do
    path =
      @configs_api_path
      |> Path.join("/config/unlock")

    body = %{project: project_name, config: config_name}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
    end
  end

  def set_config_inheritable(project_name, config_name, is_inheritable) do
    path =
      @configs_api_path
      |> Path.join("/config/inheritable")

    body = %{project: project_name, config: config_name, inheritable: is_inheritable}

    with {:ok, %{body: body}} <- Requester.post(path, json: body) do
      {:ok, Config.build(body["config"])}
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
end
