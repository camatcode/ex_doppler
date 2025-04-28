defmodule ExDoppler.Project do
  @moduledoc false
  import ExDoppler.Model

  defstruct [:created_at, :description, :id, :name, :slug]

  def build(project), do: struct(ExDoppler.Project, prepare_keys(project))
end
