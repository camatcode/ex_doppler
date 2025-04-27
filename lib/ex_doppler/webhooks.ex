defmodule ExDoppler.Webhooks do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @webhooks_api_path "/v3/webhooks"

  def list_webhooks(opts \\ []) do
    opts = Keyword.merge([project: nil], opts)

    with {:ok, %{body: body}} <- Requester.get(@webhooks_api_path, qparams: opts) do
      webhooks =
        body["webhooks"]
        |> Enum.map(fn {key, val} ->
          key = String.to_atom(key)
          {key, val}
        end)

      # TODO don't know enough info to make a struct
      {:ok, webhooks}
    end
  end
end
