defmodule ExDoppler.ServiceTokens do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @service_tokens_api_path "/v3/configs/config/tokens"

  def list_service_tokens(project_name, config_name) do
    with {:ok, %{body: body}} <-
           Requester.get(@service_tokens_api_path,
             qparams: [project: project_name, config: config_name]
           ) do
      tokens =
        body["tokens"]
        |> Enum.map(&build_service_token/1)

      {:ok, tokens}
    end
  end

  def build_service_token(token) do
    fields =
      token
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.ServiceToken, fields)
  end
end
