defmodule ExDoppler.Environment do
  @moduledoc false
  import ExDoppler.Model
  defstruct [:created_at, :id, :initial_fetch_at, :name, :project, :slug]

  def build(env), do: struct(ExDoppler.Environment, atomize_keys(env))
end
