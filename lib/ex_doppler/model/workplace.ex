defmodule ExDoppler.Workplace do
  @moduledoc false
  defstruct [:billing_email, :name, :security_email, :id]
  import ExDoppler.Model

  def build(wp), do: struct(ExDoppler.Workplace, prepare_keys(wp))
end
