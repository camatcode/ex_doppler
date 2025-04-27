defmodule ExDoppler.Workplaces do
  @moduledoc false

  alias ExDoppler.Util.Requester
  alias ExDoppler.Workplace

  @workplace_api_path "/v3/workplace"

  def get_workplace(opts \\ []) do
    with {:ok, %{body: body}} <- Requester.get(@workplace_api_path, opts) do
      {:ok, Workplace.build(body["workplace"])}
    end
  end

  def list_permissions do
    Path.join(@workplace_api_path, "/permissions")
    |> Requester.get()
    |> case do
      {:ok, %{body: body}} ->
        {:ok, body["permissions"]}

      err ->
        err
    end
  end
end
