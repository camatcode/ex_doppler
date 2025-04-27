defmodule ExDoppler.ServiceTokens do
  @moduledoc false

  alias ExDoppler.ServiceToken
  alias ExDoppler.Util.Requester

  @service_tokens_api_path "/v3/configs/config/tokens"

  def list_service_tokens(project_name, config_name)
      when is_bitstring(project_name) and is_bitstring(config_name) do
    with {:ok, %{body: body}} <-
           Requester.get(@service_tokens_api_path,
             qparams: [project: project_name, config: config_name]
           ) do
      tokens =
        body["tokens"]
        |> Enum.map(&ServiceToken.build/1)

      {:ok, tokens}
    end
  end
end
