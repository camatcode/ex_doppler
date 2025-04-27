defmodule ExDoppler.Secrets do
  @moduledoc false

  alias ExDoppler.Util.Requester
  alias ExDoppler.Secret

  @list_secrets_api_path "/v3/configs/config/secrets"
  @get_secrets_api_path "/v3/configs/config/secret"

  def list_secrets(project_name, config_name, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
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
        |> Enum.map(&build_secret/1)

      {:ok, secrets}
    end
  end

  def get_secret(project_name, config_name, secret_name)
      when is_bitstring(project_name) and is_bitstring(config_name) and is_bitstring(secret_name) do
    opts = [project: project_name, config: config_name, name: secret_name]

    with {:ok, %{body: body}} <- Requester.get(@get_secrets_api_path, qparams: opts) do
      {:ok, build_secret({body["name"], body["value"]})}
    end
  end

  def download(project_name, config_name, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
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

  def list_secret_names(project_name, config_name, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
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

  def create_secret(project_name, config_name, new_secret_name, value, opts \\ []) do
    update_secret(project_name, config_name, new_secret_name, value, opts)
  end

  def update_secret(project_name, config_name, secret_name, value, opts \\ [])
      when is_bitstring(project_name) and
             is_bitstring(config_name) and
             is_bitstring(secret_name) and
             is_bitstring(value) do
    secret =
      get_secret(project_name, config_name, secret_name)
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
        |> Enum.map(&build_secret/1)
        |> Enum.filter(fn %{name: name} ->
          name == secret_name
        end)
        |> hd()

      {:ok, secret}
    end
  end

  def delete_secret(project_name, config_name, secret_name)
      when is_bitstring(project_name) and
             is_bitstring(config_name) and
             is_bitstring(secret_name) do
    opts = [qparams: [project: project_name, config: config_name, name: secret_name]]

    with {:ok, %{body: body}} <- Requester.delete(@get_secrets_api_path, opts) do
      {:ok, {:success, true}}
    end
  end

  defp build_secret({name, map}) do
    fields =
      Map.put(map, "name", name)
      |> Enum.map(fn {key, val} ->
        # Doppler foolishly uses camelCase for this
        key = ProperCase.snake_case(key) |> String.to_atom()
        {key, val}
      end)

    struct(Secret, fields)
  end
end
