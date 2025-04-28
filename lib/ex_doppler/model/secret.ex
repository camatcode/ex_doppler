defmodule ExDoppler.Secret do
  @moduledoc false

  import ExDoppler.Model

  defstruct [:name, :raw, :computed, :note, :raw_visibility, :computed_visibility]

  def build({name, map}) do
    fields =
      Map.put(map, "name", name)
      |> prepare_keys()

    struct(ExDoppler.Secret, fields)
  end
end
