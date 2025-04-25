defmodule ExDoppler.Workplaces do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def workplace_api_path, do: "/v3/workplace"
  def workplace_users_api_path, do: Path.join(workplace_api_path(), "/users")

  def get_workplace(opts \\ []) do
    Requester.get(workplace_api_path(), opts)
    |> case do
      {:ok, %{body: body}} ->
        workplace =
          body["workplace"]
          |> Enum.map(fn {key, val} -> {String.to_existing_atom(key), val} end)

        {:ok, struct(ExDoppler.Workplace, workplace)}

      err ->
        err
    end
  end
end
