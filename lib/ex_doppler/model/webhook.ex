# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Webhook do
  @moduledoc """
  Module describing a Webhook

  <!-- tabs-open -->
  ### Fields
    * `authentication` - See `ExDoppler.WebhookAuth`
    * `can_manage` - Token in use can manage this webhook (e.g `true`)
    * `enabled` - Whether webhook is enabled (e.g `true`)
    * `enabled_configs` - List of configs for which the webhook is active (e.g `["dev", "github"]`)
    * `has_secret` - See https://docs.doppler.com/docs/webhooks#verify-webhook-with-request-signing (e.g `false`)
    * `id` - Unique ID for webhook, (e.g `"00000000-0000-0000-0000-000000000000"`)
    * `name` - Human readable name for webhook (e.g `"my-new-webhook"`)
    * `url` - Webhook's URL (e.g `"https://httpbin.org/post"`)

  #{ExDoppler.Doc.resources("webhooks", "webhooks-list")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  alias ExDoppler.WebhookAuth

  defstruct [
    :authentication,
    :can_manage,
    :enabled,
    :enabled_configs,
    :has_secret,
    :id,
    :name,
    :url
  ]

  @doc """
  Creates a `Webhook` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **webhook**: Map of fields to turn into a `Webhook`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.Webhook{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = webhook) do
    fields =
      webhook
      |> prepare()
      |> Enum.map(fn {k, v} -> {k, serialize(k, v)} end)

    struct(ExDoppler.Webhook, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:authentication, val), do: WebhookAuth.build(val)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.WebhookAuth do
  @moduledoc """
  Module describing a WebhookAuth. See `ExDoppler.Webhook`

  <!-- tabs-open -->
  ### Fields
    * `type` - either `"Basic"` or `"Bearer"`
    * `token` - If `type = "Bearer"`, the Bearer token
    * `username` - If `type = "Basic"`, the username to use. (e.g `"joe"`)
    * `has_password` - If `type = "Basic"`, that there is a password associated. (e.g `false`)

  #{ExDoppler.Doc.resources("webhooks", "webhooks-list")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  defstruct [
    :type,
    :token,
    :username,
    :has_password
  ]

  @doc """
  Creates a `WebhookAuth` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **auth**: Map of fields to turn into a `WebhookAuth`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.WebhookAuth{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = auth), do: struct(ExDoppler.WebhookAuth, prepare(auth))
end
