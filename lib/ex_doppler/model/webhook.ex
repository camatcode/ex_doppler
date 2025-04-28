defmodule ExDoppler.Webhook do
  @moduledoc false

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

  def build(webhook) do
    fields =
      webhook
      |> prepare_keys()
      |> Enum.map(fn {k, v} -> {k, serialize(k, v)} end)

    struct(ExDoppler.Webhook, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:authentication, val), do: WebhookAuth.build(val)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.WebhookAuth do
  @moduledoc false

  import ExDoppler.Model

  defstruct [
    :type,
    :token,
    :username,
    :has_password
  ]

  def build(auth), do: struct(ExDoppler.WebhookAuth, prepare_keys(auth))
end
