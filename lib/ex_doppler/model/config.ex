defmodule ExDoppler.Config do
  @moduledoc false
  import ExDoppler.Model

  defstruct [
    :created_at,
    :environment,
    :inheritable,
    :inheriting,
    :inherits,
    :initial_fetch_at,
    :last_fetch_at,
    :locked,
    :name,
    :project,
    :root,
    :slug
  ]

  def build(config), do: struct(ExDoppler.Config, atomize_keys(config))
end
