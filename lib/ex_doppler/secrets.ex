defmodule ExDoppler.Secrets do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def list_secrets_api_path, do: "/v3/configs/config/secrets"
  def get_secrets_api_path, do: "/v3/configs/config/secret"

  def list_secrets(project_name, config_name, opts \\ []) do
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

    list_secrets_api_path()
    |> Requester.get(qparams: opts)
    |> case do
      {:ok, %{body: body}} ->
        secrets =
          body["secrets"]
          |> Enum.map(&build_secret/1)

        {:ok, secrets}

      err ->
        err
    end
  end

  def get_secret(project_name, config_name, secret_name) do
    opts = [project: project_name, config: config_name, name: secret_name]

    get_secrets_api_path()
    |> Requester.get(qparams: opts)
    |> case do
      {:ok, %{body: body}} ->
        {:ok, build_secret({body["name"], body["value"]})}

      err ->
        err
    end
  end

  def download(project_name, config_name, opts \\ []) do
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

    list_secrets_api_path()
    |> Path.join("/download")
    |> Requester.get(qparams: opts, decode_body: false)
    |> case do
      {:ok, %{body: body}} ->
        {:ok, body}

      err ->
        err
    end
  end

  def list_secret_names(project_name, config_name, opts \\ []) do
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

    list_secrets_api_path()
    |> Path.join("/names")
    |> Requester.get(qparams: opts)
    |> case do
      {:ok, %{body: body}} ->
        {:ok, body["names"]}

      err ->
        err
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

    struct(ExDoppler.Secret, fields)
  end
end
