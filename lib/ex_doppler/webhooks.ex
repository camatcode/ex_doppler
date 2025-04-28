defmodule ExDoppler.Webhooks do
  @moduledoc false

  alias ExDoppler.Project
  alias ExDoppler.Util.Requester
  alias ExDoppler.Webhook

  @webhooks_api_path "/v3/webhooks"

  def list_webhooks(%Project{name: name}) do
    opts = [qparams: [project: name]]

    with {:ok, %{body: body}} <- Requester.get(@webhooks_api_path, opts) do
      webhooks =
        body["webhooks"]
        |> Enum.map(&Webhook.build/1)

      {:ok, webhooks}
    end
  end

  def list_webhooks!(%Project{} = project) do
    with {:ok, webhooks} <- list_webhooks(project) do
      webhooks
    end
  end

  def get_webhook(%Project{name: project_name}, id) when is_bitstring(id) do
    path =
      @webhooks_api_path
      |> Path.join("/webhook/#{id}")

    opts = [qparams: [project: project_name]]

    with {:ok, %{body: body}} <- Requester.get(path, opts) do
      {:ok, Webhook.build(body["webhook"])}
    end
  end

  def get_webhook!(%Project{} = project, id) do
    with {:ok, webhook} <- get_webhook(project, id) do
      webhook
    end
  end

  def enable_webhook(%Project{name: project_name}, %Webhook{id: id}) do
    path =
      @webhooks_api_path
      |> Path.join("/webhook/#{id}/enable")

    opts = [qparams: [project: project_name]]

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, Webhook.build(body["webhook"])}
    end
  end

  def enable_webhook!(%Project{} = project, %Webhook{} = webhook) do
    with {:ok, webhook} <- enable_webhook(project, webhook) do
      webhook
    end
  end

  def disable_webhook(%Project{name: project_name}, %Webhook{id: id}) do
    path =
      @webhooks_api_path
      |> Path.join("/webhook/#{id}/disable")

    opts = [qparams: [project: project_name]]

    with {:ok, %{body: body}} <- Requester.post(path, opts) do
      {:ok, Webhook.build(body["webhook"])}
    end
  end

  def disable_webhook!(%Project{} = project, %Webhook{} = webhook) do
    with {:ok, webhook} <- disable_webhook(project, webhook) do
      webhook
    end
  end

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

  def create_webhook!(%Project{} = project, url, opts \\ []) do
    with {:ok, webhook} <- create_webhook(project, url, opts) do
      webhook
    end
  end

  def delete_webhook(%Project{name: project_name}, %Webhook{id: id}) do
    path =
      @webhooks_api_path
      |> Path.join("/webhook/#{id}")

    opts = [qparams: [project: project_name]]

    with {:ok, %{body: _}} <- Requester.delete(path, opts) do
      {:ok, %{success: true}}
    end
  end

  def delete_webhook!(%Project{} = project, %Webhook{} = webhook) do
    with {:ok, _} <- delete_webhook(project, webhook) do
      :ok
    end
  end
end
