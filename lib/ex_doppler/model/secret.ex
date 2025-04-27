defmodule ExDoppler.Secret do
  @moduledoc false

  defstruct [:name, :raw, :computed, :note, :raw_visibility, :computed_visibility]

  def build({name, map}) do
    fields =
      Map.put(map, "name", name)
      |> Enum.map(fn {key, val} ->
        # Doppler foolishly uses camelCase for this
        key = ProperCase.snake_case(key) |> String.to_atom()
        {key, val}
      end)

    struct(ExDoppler.Secret, fields)
  end
end
