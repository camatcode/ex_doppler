defmodule ExDoppler.Share do
  @moduledoc false
  import ExDoppler.Model

  defstruct [:url, :authenticated_url, :password]

  def build(token), do: struct(ExDoppler.Share, prepare_keys(token))
end
