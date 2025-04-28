defmodule ExDoppler.ProjectRole do
  @moduledoc false
  import ExDoppler.Model

  defstruct [:created_at, :identifier, :is_custom_role, :name, :permissions]

  def build(role), do: struct(ExDoppler.ProjectRole, prepare_keys(role))
end
