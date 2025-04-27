defmodule ExDoppler.ActivityLog do
  @moduledoc false
  import ExDoppler.Model

  defstruct [
    :created_at,
    :diff,
    :enclave_config,
    :enclave_environment,
    :enclave_project,
    :html,
    :id,
    :text,
    :user
  ]

  def build(activity_log) do
    fields =
      activity_log
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ActivityLog, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:user, val), do: struct(ExDoppler.User, atomize_keys(val))
  defp serialize(:diff, val), do: struct(ExDoppler.ActivityDiff, atomize_keys(val))
  defp serialize(_, val), do: val
end

defmodule ExDoppler.ActivityDiff do
  @moduledoc false
  defstruct [:added, :removed, :updated]
end
