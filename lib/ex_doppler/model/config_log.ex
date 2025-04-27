defmodule ExDoppler.ConfigLog do
  @moduledoc false

  import ExDoppler.Model

  defstruct [:config, :created_at, :environment, :html, :id, :project, :rollback, :text, :user]

  def build(log) do
    fields =
      log
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ConfigLog, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:user, val), do: struct(ExDoppler.User, atomize_keys(val))
  defp serialize(_, val), do: val
end
