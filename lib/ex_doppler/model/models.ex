defmodule ExDoppler.Model do
  @moduledoc false

  def atomize_keys(m) do
    m
    |> Enum.map(fn {key, val} ->
      key = String.to_atom(key)
      {key, val}
    end)
  end
end
