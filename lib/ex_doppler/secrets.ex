# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Secrets do
  @moduledoc """
  Module for interacting with `ExDoppler.Secret`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("secrets", "secrets-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Config
  alias ExDoppler.Secret
  alias ExDoppler.Util.Requester

  @list_secrets_api_path "/v3/configs/config/secrets"
  @get_secrets_api_path "/v3/configs/config/secret"

  @doc """
  Lists `ExDoppler.Secret`

  <!-- tabs-open -->

  ### Params
    * **config**: Config to get secrets from (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
    * **opts**: Optional modifications to the list call
      * **include_dynamic_secrets** - whether to include dynamic secrets. Default: `false`
      * **include_managed_secrets** - whether to include dynamic secrets. Default: `true`
      * **secrets** - A comma-separated list of secrets to include in the response. Default: `nil`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.Secret{...} ...]}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("secrets-list")}

  <!-- tabs-close -->
  """
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

  @doc """
  Same as `list_secrets/2` but won't wrap a successful response in `{:ok, response}`
  """
  def list_secrets!(%Config{} = config, opts \\ []) do
    with {:ok, secrets} <- list_secrets(config, opts) do
      secrets
    end
  end

  @doc """
  Retrieves a `ExDoppler.Secret`

  <!-- tabs-open -->

  ### Params
   * **config** - Config to get secrets from (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **secret_name** - Name of the secret to get (e.g `"API_KEY"`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Secret{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("secrets-get")}

  <!-- tabs-close -->
  """
  def get_secret(%Config{name: config_name, project: project_name}, secret_name)
      when is_bitstring(secret_name) do
    opts = [project: project_name, config: config_name, name: secret_name]

    with {:ok, %{body: body}} <- Requester.get(@get_secrets_api_path, qparams: opts) do
      {:ok, Secret.build({body["name"], body["value"]})}
    end
  end

  @doc """
  Same as `get_secret/2` but won't wrap a successful response in `{:ok, response}`
  """
  def get_secret!(%Config{} = config, secret_name) do
    with {:ok, secret} <- get_secret(config, secret_name) do
      secret
    end
  end

  @doc """
  Retrieves multiple `ExDoppler.Secret` and responds in a format ready to put into a file

  <!-- tabs-open -->

  ### Params
   * **config** - Config to get secrets from (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **opts**: Optional modifications to the download call
      * **include_dynamic_secrets** - whether to include dynamic secrets. Default: `false`
      * **dynamic_secrets_ttl_sec** - The number of seconds until dynamic leases expire. Must be used with include_dynamic_secrets. Defaults to 1800 (30 minutes). Default: `nil`
      * **format** - File format to use. (e.g `"dotnet-json"`, `"env"`, `"yaml"`, `"docker"`, `"env-no-quotes"`) Default: `json`
      * **name_transformer** - Transform secret names to a different case (e.g `"camel"`, `"upper-camel"`, `"lower-snake"`, `"tf-var"`, `"dotnet"`, `"dotnet-env"`, `"lower-kebab"`). Default: `nil`
      * **secrets** - Comma-delimited list of secrets to include in the download. Defaults to all secrets if left unspecified.

  #{ExDoppler.Doc.returns(success: "{:ok, requested_body}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("secrets-download")}

  <!-- tabs-close -->
  """
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

  @doc """
  Same as `download/2` but won't wrap a successful response in `{:ok, response}`
  """
  def download!(%Config{} = config, opts \\ []) do
    with {:ok, body} <- download(config, opts) do
      body
    end
  end

  @doc """
  Lists the names of `ExDoppler.Secret`, given a config and options

  <!-- tabs-open -->

  ### Params
   * **config** - Config to get secrets from (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **opts**: Optional modifications to the list call
      * **include_dynamic_secrets** - whether to include dynamic secrets. Default: `false`
      * **include_managed_secrets** - whether to include managed secrets. Default: `true`


  #{ExDoppler.Doc.returns(success: "{:ok, names}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("secrets-names")}

  <!-- tabs-close -->
  """
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

  @doc """
  Same as `list_secret_names/2` but won't wrap a successful response in `{:ok, response}`
  """
  def list_secret_names!(%Config{} = config, opts \\ []) do
    with {:ok, names} <- list_secret_names(config, opts) do
      names
    end
  end

  @doc """
  Creates a new `ExDoppler.Secret`

  <!-- tabs-open -->

  ### Params
   * **config** - Config to get secrets from (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **new_secret_name** - Name of this new secret
   * **value** - Value of this new secret
   * **opts**: Optional modifications
      * **visibility** - how the secret should appear - `:masked`, `:unmasked`, or `:restricted`. Default: `:masked`

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Secret{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("secrets-update")}

  <!-- tabs-close -->
  """
  def create_secret(%Config{} = config, new_secret_name, value, opts \\ []) do
    update_secret(config, new_secret_name, value, opts)
  end

  @doc """
  Same as `create_secret/4` but won't wrap a successful response in `{:ok, response}`
  """
  def create_secret!(%Config{} = config, new_secret_name, value, opts \\ []) do
    update_secret!(config, new_secret_name, value, opts)
  end

  @doc """
  Updates a `ExDoppler.Secret`

  <!-- tabs-open -->

  ### Params
   * **config** - Config to get secrets from (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **secret_name** - Name of this secret
   * **value** - Value of this secret
   * **opts**: Optional modifications
      * **visibility** - how the secret should appear - `:masked`, `:unmasked`, or `:restricted`. Default: `:masked`
      * **should_promote** - Defaults to false. Can only be set to true if the config being updated is a branch config. If set to true, the provided secret will be set in both the branch config as well as the root config in that environment.
      * **should_delete** - Defaults to false. If set to true, will delete the secret matching the name field.
      * **should_converge** - Defaults to false. Can only be set to true if the config being updated is a branch config and there is a secret with the same name in the root config. In this case, the branch secret will inherit the value and visibility type from the root secret.

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Secret{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("secrets-update")}

  <!-- tabs-close -->
  """
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

  @doc """
  Same as `update_secret/4` but won't wrap a successful response in `{:ok, response}`
  """
  def update_secret!(%Config{} = config, secret_name, value, opts \\ []) do
    with {:ok, secret} <- update_secret(config, secret_name, value, opts) do
      secret
    end
  end

  @doc """
  Updates the `note` field on a  `ExDoppler.Secret`

  <!-- tabs-open -->

  ### Params
   * **project_name** - Name of the associated project (e.g `"example-project"`)
   * **secret_name** - Name of this secret
   * **note** - Attached Note

  #{ExDoppler.Doc.returns(success: "{:ok, %{note: note secret: %ExDoppler.Secret{...}}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("secrets-update_note")}

  <!-- tabs-close -->
  """
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

  @doc """
  Same as `update_secret_note/3` but won't wrap a successful response in `{:ok, response}`
  """
  def update_secret_note!(project_name, secret_name, note) do
    with {:ok, body} <- update_secret_note(project_name, secret_name, note) do
      body
    end
  end

  @doc """
  Deletes a `ExDoppler.Secret`

  <!-- tabs-open -->

  ### Params
   * **config** - Config to get secrets from (e.g `%Config{name: "dev_personal", project: "example-project" ...}`)
   * **secret_name** - Name of secret to delete

  #{ExDoppler.Doc.returns(success: "{:ok, {:success, true}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("secrets-delete")}

  <!-- tabs-close -->
  """
  def delete_secret(%Config{name: config_name, project: project_name}, secret_name)
      when is_bitstring(secret_name) do
    opts = [qparams: [project: project_name, config: config_name, name: secret_name]]

    with {:ok, %{body: _}} <- Requester.delete(@get_secrets_api_path, opts) do
      {:ok, {:success, true}}
    end
  end

  @doc """
  Same as `delete_secret/2` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_secret!(%Config{} = config, secret_name) do
    with {:ok, _} <- delete_secret(config, secret_name) do
      :ok
    end
  end
end
