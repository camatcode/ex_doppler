# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Webhooks do
  @moduledoc """
  Module for interacting with `ExDoppler.Webhook`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("webhooks", "webhooks-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Project
  alias ExDoppler.Requester
  alias ExDoppler.Webhook

  @webhooks_api_path "/v3/webhooks"

  @doc """
  Lists `ExDoppler.Webhook`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project** -  The `ExDoppler.Project` for which you want the webhooks (e.g `%Project{name: "example-project"}`)

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.Webhook{...} ...]}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("webhooks-list")}

  <!-- tabs-close -->
  """
  def list_webhooks(%Project{name: name}) do
    opts = [qparams: [project: name]]

    with {:ok, %{body: body}} <- Requester.get(@webhooks_api_path, opts) do
      webhooks =
        body["webhooks"]
        |> Enum.map(&Webhook.build/1)

      {:ok, webhooks}
    end
  end

  @doc """
  Same as `list_webhooks/1` but won't wrap a successful response in `{:ok, response}`
  """
  def list_webhooks!(%Project{} = project) do
    with {:ok, webhooks} <- list_webhooks(project) do
      webhooks
    end
  end

  @doc """
  Retrieves a `ExDoppler.Webhook`, given a project and a webhook id

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project** -  The `ExDoppler.Project` for which you want the webhooks (e.g `%Project{name: "example-project"}`)
    * **id** - ID of the webhook to retrieve

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Webhook{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("webhooks-get")}

  <!-- tabs-close -->
  """
  def get_webhook(%Project{name: project_name}, id) when is_bitstring(id) do
    path =
      @webhooks_api_path
      |> Path.join("/webhook/#{id}")

    opts = [qparams: [project: project_name]]

    with {:ok, %{body: body}} <- Requester.get(path, opts) do
      {:ok, Webhook.build(body["webhook"])}
    end
  end

  @doc """
  Same as `get_webhook/2` but won't wrap a successful response in `{:ok, response}`
  """
  def get_webhook!(%Project{} = project, id) do
    with {:ok, webhook} <- get_webhook(project, id) do
      webhook
    end
  end

  @doc """
  Enables a `ExDoppler.Webhook`, given a project and a webhook

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project** -  The `ExDoppler.Project` for which you want the webhooks (e.g `%Project{name: "example-project"}`)
    * **webhook** - The `ExDoppler.Webhook` to enable (e.g %Webhook{id: "my-new-webhook" ...}

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Webhook{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("webhooks-enable")}

  <!-- tabs-close -->
  """
  def enable_webhook(%Project{name: project_name}, %Webhook{id: id}) do
    path =
      @webhooks_api_path
      |> Path.join("/webhook/#{id}/enable")

    opts = [qparams: [project: project_name]]

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, Webhook.build(body["webhook"])}
    end
  end

  @doc """
  Same as `enable_webhook/2` but won't wrap a successful response in `{:ok, response}`
  """
  def enable_webhook!(%Project{} = project, %Webhook{} = webhook) do
    with {:ok, webhook} <- enable_webhook(project, webhook) do
      webhook
    end
  end

  @doc """
  Disables a `ExDoppler.Webhook`, given a project and a webhook

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project** -  The `ExDoppler.Project` for which you want the webhooks (e.g `%Project{name: "example-project"}`)
    * **webhook** - The `ExDoppler.Webhook` to enable (e.g %Webhook{id: "my-new-webhook" ...}

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Webhook{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("webhooks-disable")}

  <!-- tabs-close -->
  """
  def disable_webhook(%Project{name: project_name}, %Webhook{id: id}) do
    path =
      @webhooks_api_path
      |> Path.join("/webhook/#{id}/disable")

    opts = [qparams: [project: project_name]]

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, Webhook.build(body["webhook"])}
    end
  end

  @doc """
  Same as `disable_webhook/2` but won't wrap a successful response in `{:ok, response}`
  """
  def disable_webhook!(%Project{} = project, %Webhook{} = webhook) do
    with {:ok, webhook} <- disable_webhook(project, webhook) do
      webhook
    end
  end

  @doc """
  Creates a new `ExDoppler.Webhook`, given a project, a webhook URL, and options

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project** -  The `ExDoppler.Project` for which you want the webhooks (e.g `%Project{name: "example-project"}`)
    * **url**: The webhook URL. Must be https (e.g `"https://httpbin.org/post"`)
    * **opts**: Optional modifications
      * **name** - The name of the webhook (e.g "`my-web-hook"`)
      * **secret** - See https://docs.doppler.com/docs/webhooks#verify-webhook-with-request-signing
      * **payload** - See https://docs.doppler.com/docs/webhooks#default-payload
      * **enable_configs** - List of Config slugs that the webhook should be enabled for. Default: `[]`
      * **authentication** - Either `%{type: :Bearer, token: "BEARER TOKEN HERE"}` or `%{type: :Basic, username: "example_user", password: "pass"}`

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.Webhook{...}}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("webhooks-add")}

  <!-- tabs-close -->
  """
  def create_webhook(%Project{name: project_name}, url, opts \\ [])
      when is_bitstring(url) do
    # Doppler uses camelCase for this route
    body =
      %{
        url: url,
        secret: opts[:secret],
        payload: opts[:payload],
        enableConfigs: opts[:enable_configs],
        name: opts[:name],
        authentication: opts[:authentication]
      }
      |> Enum.filter(fn {_k, v} -> v != nil end)
      |> Enum.into(%{})

    opts = [qparams: [project: project_name], json: body]

    with {:ok, %{body: body}} <- Requester.post(@webhooks_api_path, opts) do
      {:ok, Webhook.build(body["webhook"])}
    end
  end

  @doc """
  Same as `create_webhook/3` but won't wrap a successful response in `{:ok, response}`
  """
  def create_webhook!(%Project{} = project, url, opts \\ []) do
    with {:ok, webhook} <- create_webhook(project, url, opts) do
      webhook
    end
  end

  @doc """
  Deletes a `ExDoppler.Webhook`

  <!-- tabs-open -->

  ### 🏷️ Params
    * **project** -  The `ExDoppler.Project` for which you want the webhooks (e.g `%Project{name: "example-project"}`)

  #{ExDoppler.Doc.returns(success: "{:ok, {:success, true}", failure: "{:err, err}")}

  #{ExDoppler.Doc.resources("webhooks-delete")}

  <!-- tabs-close -->
  """
  def delete_webhook(%Project{name: project_name}, %Webhook{id: id}) do
    path =
      @webhooks_api_path
      |> Path.join("/webhook/#{id}")

    opts = [qparams: [project: project_name]]

    with {:ok, %{body: _}} <- Requester.delete(path, opts) do
      {:ok, {:success, true}}
    end
  end

  @doc """
  Same as `delete_webhook/2` but won't wrap a successful response in `{:ok, response}`
  """
  def delete_webhook!(%Project{} = project, %Webhook{} = webhook) do
    with {:ok, _} <- delete_webhook(project, webhook) do
      :ok
    end
  end
end
