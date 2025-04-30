# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.Model do
  @moduledoc false

  def prepare_keys(m) do
    m
    |> snake_case_keys()
    |> atomize_keys()
  end

  def snake_case_keys(m) do
    m
    |> Enum.map(fn {key, val} ->
      {ProperCase.snake_case(key), val}
    end)
  end

  def atomize_keys(m) do
    m
    |> Enum.map(fn {key, val} ->
      key = String.to_atom(key)
      {key, val}
    end)
  end
end
