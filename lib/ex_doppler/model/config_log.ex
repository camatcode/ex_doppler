defmodule ExDoppler.ConfigLog do
  @moduledoc """
  Module describing a [Doppler Config Log](https://docs.doppler.com/reference/config_logs-object)

  ### Fields
    * `config` - Name of the config (e.g `"dev_personal"`)
    * `created_at` - Date and time of config log's creation (e.g `"2025-04-28T16:09:17.737Z"`)
    * `environment` - Unique identifier for the environment object (e.g `"dev"`)
    * `html` - HTML describing the event.
    * `id` - Unique identifier for the object (e.g `"Ul8KeqJzKK3n7OadwqX5RZW2"`)
    * `project` - Unique identifier for the project object (e.g `"example-project"`)
    * `rollback` - Whether this config log a rollback of a previous log.
    * `text` - Text describing the event (e.g `"Modified secrets and saved to vault"`)
    * `user` - Relevant User. See `ExDoppler.User`
  """

  import ExDoppler.Model

  alias ExDoppler.User

  defstruct [:config, :created_at, :environment, :html, :id, :project, :rollback, :text, :user]

  @doc """
  Creates an `ConfigLog` from a map

  ### Params
    * **log**: Map of fields to turn into a `ConfigLog`
  """
  def build(%{} = log) do
    fields =
      log
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ConfigLog, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:user, val), do: User.build(val)
  defp serialize(_, val), do: val
end
