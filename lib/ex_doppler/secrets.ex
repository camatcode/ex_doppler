defmodule ExDoppler.Secrets do
  @moduledoc false

  alias ExDoppler.Config
  alias ExDoppler.Secret
  alias ExDoppler.Util.Requester

  @list_secrets_api_path "/v3/configs/config/secrets"
  @get_secrets_api_path "/v3/configs/config/secret"

  def list_secrets(%Config{name: config_name, project: project_name}, opts \\ []) do
    opts =
      Keyword.merge(
        [
          project: project_name,
          config: config_name,
          include_dynamic_secrets: false,
          secrets: nil,
          include_managed_secrets: true
        ],
        opts
      )

    with {:ok, %{body: body}} <- Requester.get(@list_secrets_api_path, qparams: opts) do
      secrets =
        body["secrets"]
        |> Enum.map(&Secret.build/1)

      {:ok, secrets}
    end
  end

  def get_secret(%Config{name: config_name, project: project_name}, secret_name)
      when is_bitstring(secret_name) do
    opts = [project: project_name, config: config_name, name: secret_name]

    with {:ok, %{body: body}} <- Requester.get(@get_secrets_api_path, qparams: opts) do
      {:ok, Secret.build({body["name"], body["value"]})}
    end
  end

  def download(%Config{name: config_name, project: project_name}, opts \\ []) do
    opts =
      Keyword.merge(
        [
          project: project_name,
          config: config_name,
          format: "json",
          name_transformer: nil,
          include_dynamic_secrets: false,
          dynamic_secrets_ttl_sec: nil,
          secrets: nil
        ],
        opts
      )

    path =
      @list_secrets_api_path
      |> Path.join("/download")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: opts, decode_body: false) do
      {:ok, body}
    end
  end

  def list_secret_names(%Config{name: config_name, project: project_name}, opts \\ []) do
    opts =
      Keyword.merge(
        [
          project: project_name,
          config: config_name,
          include_dynamic_secrets: false,
          include_managed_secrets: true
        ],
        opts
      )

    path =
      @list_secrets_api_path
      |> Path.join("/names")

    with {:ok, %{body: body}} <- Requester.get(path, qparams: opts) do
      {:ok, body["names"]}
    end
  end

  def create_secret(%Config{} = config, new_secret_name, value, opts \\ []) do
    update_secret(config, new_secret_name, value, opts)
  end

  def update_secret(
        %Config{name: config_name, project: project_name} = config,
        secret_name,
        value,
        opts \\ []
      )
      when is_bitstring(secret_name) and is_bitstring(value) do
    secret =
      get_secret(config, secret_name)
      |> case do
        {:ok, secret} -> secret
        _ -> nil
      end

    # Doppler foolishly uses camelCase for this route
    opts =
      opts
      |> Enum.map(fn
        {k, v} ->
          {ProperCase.camel_case(k) |> String.to_atom(), v}
      end)

    opts =
      Keyword.merge(
        [
          name: secret_name,
          originalName: (secret && secret.name) || nil,
          value: value,
          visibility: :masked,
          shouldPromote: false,
          shouldDelete: false,
          shouldConverge: false
        ],
        opts
      )

    change_request = opts |> Enum.filter(fn {_k, v} -> v end) |> Enum.into(%{})

    body =
      %{project: project_name, config: config_name, change_requests: [change_request]}

    with {:ok, %{body: body}} <- Requester.post(@list_secrets_api_path, json: body) do
      secret =
        body["secrets"]
        |> Enum.map(&Secret.build/1)
        |> Enum.filter(fn %{name: name} ->
          name == secret_name
        end)
        |> hd()

      {:ok, secret}
    end
  end

  def update_secret_note(project_name, secret_name, note)
      when is_bitstring(project_name) and
             is_bitstring(secret_name) and
             is_bitstring(note) do
    opts = [qparams: [project: project_name], json: %{secret: secret_name, note: note}]
    path = "/v3/projects/project/note"

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, %{note: body["note"], secret: body["secret"]}}
    end
  end

  def delete_secret(%Config{name: config_name, project: project_name}, secret_name)
      when is_bitstring(secret_name) do
    opts = [qparams: [project: project_name, config: config_name, name: secret_name]]

    with {:ok, %{body: _}} <- Requester.delete(@get_secrets_api_path, opts) do
      {:ok, {:success, true}}
    end
  end
end
