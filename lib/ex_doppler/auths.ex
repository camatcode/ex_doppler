defmodule ExDoppler.Auths do
  @moduledoc false

  alias ExDoppler.Util.Requester

  def me() do
    path = "/v3/me"

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, build_token_info(body)}
    end
  end

  defp build_token_info(token_info) do
    fields =
      token_info
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.TokenInfo, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:workplace, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.Workplace, val)
  end

  defp serialize(_, val), do: val
end
