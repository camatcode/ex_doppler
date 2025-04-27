defmodule ExDoppler.ServiceTokens do
  @moduledoc false

  alias ExDoppler.Config
  alias ExDoppler.ServiceToken
  alias ExDoppler.Util.Requester

  @service_tokens_api_path "/v3/configs/config/tokens"

  def list_service_tokens(%Config{name: config_name, project: project_name}) do
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
