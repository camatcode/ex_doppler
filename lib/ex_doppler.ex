# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler do
  @moduledoc """
  Convenience functions for interacting with Doppler

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("secrets", "secrets-list")}

  <!-- tabs-close -->
  """
  alias ExDoppler.Config
  alias ExDoppler.Secret
  alias ExDoppler.Secrets

  @doc """
  Lists `ExDoppler.Secret`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project_name**: Name of the project (e.g `"example-project"`)
    * **config_name**: Name of the config (e.g `"dev_personal"`)
    * **opts**: Optional modifications to the list call
      * **include_dynamic_secrets** - whether to include dynamic secrets. Default: `false`
      * **include_managed_secrets** - whether to include dynamic secrets. Default: `true`
      * **secrets** - A comma-separated list of secrets to include in the response. Default: `nil`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.Secret{...} ...]}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> {:ok, _secrets} = ExDoppler.list_secrets("example-project", "dev_personal")

  #{ExDoppler.Doc.resources("secrets-list")}

  <!-- tabs-close -->
  """
  def list_secrets(project_name, config_name, opts \\ []) when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.list_secrets(%Config{name: config_name, project: project_name}, opts)
  end

  @doc """
  Same as `list_secrets/3` but won't wrap a successful response in `{:ok, response}`
  """
  def list_secrets!(project_name, config_name, opts \\ []) do
    with {:ok, secrets} <- list_secrets(project_name, config_name, opts) do
      secrets
    end
  end

  @doc """
  Retrieves a `ExDoppler.Secret`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project_name**: Name of the project (e.g `"example-project"`)
    * **config_name**: Name of the config (e.g `"dev_personal"`)
    * **secret_name** - Name of the secret to get (e.g `"API_KEY"`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Secret{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> {:ok, _secret} = ExDoppler.get_secret("example-project", "dev_personal", "DB_URL")

  #{ExDoppler.Doc.resources("secrets-get")}

  <!-- tabs-close -->
  """
  def get_secret(project_name, config_name, secret_name)
      when is_bitstring(project_name) and is_bitstring(config_name) and is_bitstring(secret_name) do
    Secrets.get_secret(%Config{name: config_name, project: project_name}, secret_name)
  end

  @doc """
  Same as `get_secret/3` but won't wrap a successful response in `{:ok, response}`
  """
  def get_secret!(project_name, config_name, secret_name) do
    with {:ok, secret} <- get_secret(project_name, config_name, secret_name) do
      secret
    end
  end

  @doc """
  Retrieves the raw value of a  `ExDoppler.Secret`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project_name**: Name of the project (e.g `"example-project"`)
    * **config_name**: Name of the config (e.g `"dev_personal"`)
    * **secret_name** - Name of the secret to get (e.g `"API_KEY"`)

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Secret{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> {:ok, _raw_value} = ExDoppler.get_secret_raw("example-project", "dev_personal", "DB_URL")

  #{ExDoppler.Doc.resources("secrets-get")}

  <!-- tabs-close -->
  """
  def get_secret_raw(project_name, config_name, secret_name)
      when is_bitstring(project_name) and is_bitstring(config_name) and is_bitstring(secret_name) do
    with {:ok, secret} <-
           Secrets.get_secret(%Config{name: config_name, project: project_name}, secret_name) do
      {:ok, secret.raw}
    end
  end

  @doc """
  Same as `get_secret_raw/3` but won't wrap a successful response in `{:ok, response}`
  """
  def get_secret_raw!(project_name, config_name, secret_name)
      when is_bitstring(project_name) and is_bitstring(config_name) and is_bitstring(secret_name) do
    with %Secret{raw: raw} <-
           Secrets.get_secret!(%Config{name: config_name, project: project_name}, secret_name) do
      raw
    end
  end

  @doc """
  Retrieves multiple `ExDoppler.Secret` and responds in a format ready to put into a file

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project_name**: Name of the project (e.g `"example-project"`)
    * **config_name**: Name of the config (e.g `"dev_personal"`)
    * **opts**: Optional modifications to the download call
      * **include_dynamic_secrets** - whether to include dynamic secrets. Default: `false`
      * **dynamic_secrets_ttl_sec** - The number of seconds until dynamic leases expire. Must be used with include_dynamic_secrets. Defaults to 1800 (30 minutes). Default: `nil`
      * **format** - File format to use. (e.g `"dotnet-json"`, `"env"`, `"yaml"`, `"docker"`, `"env-no-quotes"`) Default: `json`
      * **name_transformer** - Transform secret names to a different case (e.g `"camel"`, `"upper-camel"`, `"lower-snake"`, `"tf-var"`, `"dotnet"`, `"dotnet-env"`, `"lower-kebab"`). Default: `nil`
      * **secrets** - Comma-delimited list of secrets to include in the download. Defaults to all secrets if left unspecified.

  #{ExDoppler.Doc.returns(success: "{:ok, requested_body}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> {:ok, _formatted_body} = ExDoppler.download_secrets("example-project", "dev_personal", format: :env, name_transformer: "lower-snake")

  #{ExDoppler.Doc.resources("secrets-download")}

  <!-- tabs-close -->
  """
  def download_secrets(project_name, config_name, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.download(%Config{name: config_name, project: project_name}, opts)
  end

  @doc """
  Same as `download_secrets/2` but won't wrap a successful response in `{:ok, response}`
  """
  def download_secrets!(project_name, config_name, opts \\ []) do
    with {:ok, body} <- download_secrets(project_name, config_name, opts) do
      body
    end
  end

  @doc """
  Lists the names of `ExDoppler.Secret`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project_name**: Name of the project (e.g `"example-project"`)
    * **config_name**: Name of the config (e.g `"dev_personal"`)
    * **opts**: Optional modifications to the list call
      * **include_dynamic_secrets** - whether to include dynamic secrets. Default: `false`
      * **include_managed_secrets** - whether to include managed secrets. Default: `true`


  #{ExDoppler.Doc.returns(success: "{:ok, names}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> {:ok, _names} = ExDoppler.list_secret_names("example-project", "dev_personal")

  #{ExDoppler.Doc.resources("secrets-names")}

  <!-- tabs-close -->
  """
  def list_secret_names(project_name, config_name, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.list_secrets(%Config{name: config_name, project: project_name}, opts)
  end

  @doc """
  Same as `list_secret_names/3` but won't wrap a successful response in `{:ok, response}`
  """
  def list_secret_names!(project_name, config_name, opts \\ []) do
    with {:ok, names} <- list_secret_names(project_name, config_name, opts) do
      names
    end
  end

  @doc """
  Creates a new `ExDoppler.Secret`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project_name**: Name of the project (e.g `"example-project"`)
    * **config_name**: Name of the config (e.g `"dev_personal"`)
    * **new_secret_name** - Name of this new secret
    * **value** - Value of this new secret
    * **opts**: Optional modifications
      * **visibility** - how the secret should appear - `:masked`, `:unmasked`, or `:restricted`. Default: `:masked`

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Secret{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> _ = ExDoppler.delete_secret!("example-project", "dev_personal", "DOC_URL")
      iex> {:ok, _secret} = ExDoppler.create_secret("example-project", "dev_personal", "DOC_URL", "example.com")
      iex> {:ok, {:success, true}} = ExDoppler.delete_secret("example-project", "dev_personal", "DOC_URL")

  #{ExDoppler.Doc.resources("secrets-update")}

  <!-- tabs-close -->
  """
  def create_secret(project_name, config_name, new_secret_name, value, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.create_secret(
      %Config{project: project_name, name: config_name},
      new_secret_name,
      value,
      opts
    )
  end

  @doc """
  Same as `create_secret/5` but won't wrap a successful response in `{:ok, response}`
  """
  def create_secret!(project_name, config_name, new_secret_name, value, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.create_secret!(
      %Config{project: project_name, name: config_name},
      new_secret_name,
      value,
      opts
    )
  end

  @doc """
  Updates a `ExDoppler.Secret`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project_name**: Name of the project (e.g `"example-project"`)
    * **config_name**: Name of the config (e.g `"dev_personal"`)
    * **secret_name** - Name of this secret
    * **value** - Value of this secret
    * **opts**: Optional modifications
      * **visibility** - how the secret should appear - `:masked`, `:unmasked`, or `:restricted`. Default: `:masked`
      * **should_promote** - Defaults to false. Can only be set to true if the config being updated is a branch config. If set to true, the provided secret will be set in both the branch config as well as the root config in that environment.
      * **should_delete** - Defaults to false. If set to true, will delete the secret matching the name field.
      * **should_converge** - Defaults to false. Can only be set to true if the config being updated is a branch config and there is a secret with the same name in the root config. In this case, the branch secret will inherit the value and visibility type from the root secret.

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Secret{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> _ = ExDoppler.delete_secret!("example-project", "dev_personal", "DOC_URL")
      iex> {:ok, _secret} = ExDoppler.create_secret("example-project", "dev_personal", "DOC_URL", "example.com")
      iex> {:ok, _secret} = ExDoppler.update_secret("example-project", "dev_personal", "DOC_URL", "example.com2", visibility: :unmasked)
      iex> {:ok, {:success, true}} = ExDoppler.delete_secret("example-project", "dev_personal", "DOC_URL")

  #{ExDoppler.Doc.resources("secrets-update")}

  <!-- tabs-close -->
  """
  def update_secret(project_name, config_name, secret_name, value, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.update_secret(
      %Config{project: project_name, name: config_name},
      secret_name,
      value,
      opts
    )
  end

  @doc """
  Same as `update_secret/5` but won't wrap a successful response in `{:ok, response}`
  """
  def update_secret!(project_name, config_name, secret_name, value, opts \\ [])
      when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.update_secret!(
      %Config{project: project_name, name: config_name},
      secret_name,
      value,
      opts
    )
  end

  @doc """
  Updates the `note` field on a  `ExDoppler.Secret`

  <!-- tabs-open -->

  ### 🏷️ Params
   * **project_name** - Name of the associated project (e.g `"example-project"`)
   * **secret_name** - Name of this secret
   * **note** - Attached Note

  #{ExDoppler.Doc.returns(success: "{:ok, %{note: note secret: %ExDoppler.Secret{...}}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> _ = ExDoppler.delete_secret!("example-project", "dev_personal", "DOC_URL")
      iex> {:ok, _secret} = ExDoppler.create_secret("example-project", "dev_personal", "DOC_URL", "example.com")
      iex> {:ok, _secret} = ExDoppler.update_secret_note("example-project", "DOC_URL", "a new note")
      iex> {:ok, {:success, true}} = ExDoppler.delete_secret("example-project", "dev_personal", "DOC_URL")

  #{ExDoppler.Doc.resources("secrets-update_note")}

  <!-- tabs-close -->
  """
  def update_secret_note(project_name, secret_name, note) do
    Secrets.update_secret_note(project_name, secret_name, note)
  end

  @doc """
  Same as `update_secret_note/3` but won't wrap a successful response in `{:ok, response}`
  """
  def update_secret_note!(project_name, secret_name, note) do
    Secrets.update_secret_note!(project_name, secret_name, note)
  end

  @doc """
  Deletes a `ExDoppler.Secret`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project_name**: Name of the project (e.g `"example-project"`)
    * **config_name**: Name of the config (e.g `"dev_personal"`)
    * **secret_name** - Name of secret to delete

  #{ExDoppler.Doc.returns(success: "{:ok, {:success, true}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> _ = ExDoppler.delete_secret!("example-project", "dev_personal", "DOC_URL")
      iex> {:ok, _secret} = ExDoppler.create_secret("example-project", "dev_personal", "DOC_URL", "example.com")
      iex> {:ok, {:success, true}} = ExDoppler.delete_secret("example-project", "dev_personal", "DOC_URL")

  #{ExDoppler.Doc.resources("secrets-delete")}

  <!-- tabs-close -->
  """
  def delete_secret(project_name, config_name, secret_name)
      when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.delete_secret(%Config{project: project_name, name: config_name}, secret_name)
  end

  @doc """
  Same as `delete_secret/3` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_secret!(project_name, config_name, secret_name)
      when is_bitstring(project_name) and is_bitstring(config_name) do
    Secrets.delete_secret!(%Config{project: project_name, name: config_name}, secret_name)
  end
end
