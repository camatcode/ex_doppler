defmodule ExDoppler.TokenInfo do
  @moduledoc false

  import ExDoppler.Model

  defstruct [:slug, :name, :created_at, :last_seen_at, :type, :token_preview, :workplace]

  def build(token_info) do
    fields =
      token_info
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.TokenInfo, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:workplace, val), do: struct(ExDoppler.Workplace, atomize_keys(val))
  defp serialize(_, val), do: val
end
