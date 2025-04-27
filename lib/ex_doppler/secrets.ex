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

  defp build_secret({name, map}) do
    fields =
      Map.put(map, "name", name)
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        key = if key == :rawVisibility, do: :raw_visibility, else: key
        key = if key == :computedVisibility, do: :computed_visibility, else: key
        {key, val}
      end)

    struct(Secret, fields)
  end
end
