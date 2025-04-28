defmodule ExDoppler.Integration do
  @moduledoc false
  import ExDoppler.Model

  alias ExDoppler.Sync

  defstruct [:slug, :name, :type, :kind, :enabled, :syncs]

  def build(integration) do
    fields =
      integration
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Integration, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:syncs, val), do: val |> Enum.map(&Sync.build/1)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.Sync do
  @moduledoc false

  import ExDoppler.Model

  defstruct [:slug, :enabled, :last_synced_at, :project, :config, :integration]

  def build(sync), do: struct(ExDoppler.Sync, prepare_keys(sync))
end
