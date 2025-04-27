defmodule ExDoppler.Webhook do
  @moduledoc false

  import ExDoppler.Model

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
    # Doppler uses camelCase here
    fields =
      webhook
      |> Enum.map(fn {k, v} -> {ProperCase.snake_case(k), v} end)
      |> atomize_keys()
      |> Enum.map(fn {k, v} -> {k, serialize(k, v)} end)

    struct(ExDoppler.Webhook, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:authentication, val) do
    fields =
      val
      |> Enum.map(fn {k, v} -> {ProperCase.snake_case(k), v} end)
      |> atomize_keys()

    struct(ExDoppler.WebhookAuth, fields)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.WebhookAuth do
  @moduledoc false

  defstruct [
    :type,
    :token,
    :username,
    :has_password
  ]
end
