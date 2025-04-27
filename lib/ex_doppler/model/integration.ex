defmodule ExDoppler.Integration do
  @moduledoc false
  import ExDoppler.Model
  defstruct [:slug, :name, :type, :kind, :enabled, :syncs]

  def build(integration) do
    fields =
      integration
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Integration, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:syncs, val) do
    fields =
      val
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {ProperCase.snake_case(key), val}
      end)

    struct(ExDoppler.Sync, fields)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.Sync do
  @moduledoc false

  import ExDoppler.Model

  defstruct [:slug, :enabled, :last_synced_at, :project, :config, :integration]

  def build(sync) do
    fields =
      sync
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {ProperCase.snake_case(key), val}
      end)

    struct(ExDoppler.Sync, fields)
  end
end