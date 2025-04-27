defmodule ExDoppler.ServiceToken do
  @moduledoc false
  import ExDoppler.Model

  defstruct [:name, :slug, :created_at, :config, :environment, :project, :expires_at]

  def build(token), do: struct(ExDoppler.ServiceToken, atomize_keys(token))
end
