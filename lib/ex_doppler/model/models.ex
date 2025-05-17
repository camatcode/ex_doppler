# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Model do
  @moduledoc false

  def prepare(m) do
    m
    |> prepare_values()
    |> prepare_keys()
  end

  def prepare_values(m) do
    Enum.map(m, fn {key, val} ->
      if val && String.ends_with?(key, "_at"),
        do: {key, DateTimeParser.parse_datetime!(val)},
        else: {key, val}
    end)
  end

  def prepare_keys(m) do
    m
    |> snake_case_keys()
    |> atomize_keys()
  end

  def snake_case_keys(m) do
    Enum.map(m, fn {key, val} ->
      {ProperCase.snake_case(key), val}
    end)
  end

  def atomize_keys(m) do
    Enum.map(m, fn {key, val} ->
      key = String.to_atom(key)
      {key, val}
    end)
  end
end
