# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.ActivityLog do
  @moduledoc """
  Module describing an ActivityLog

  <!-- tabs-open -->
  ### Fields
    * `created_at` - Date and time of the Activity Log's creation (e.g `"2025-04-28T16:09:17.737Z"`)
    * `diff` - Details what was added, removed or updated. See `ExDoppler.ActivityDiff`.
    * `enclave_config` - Relevant config (e.g `"github"`)
    * `enclave_environment` - Relevant environment (e.g `"github"`)
    * `enclave_project` - Relevant project (e.g `"example-project"`)
    * `html` - HTML rendering of `text`
    * `text` - Human-readable explanation of the log
    * `user` - Relevant user to this activity log. See `ExDoppler.User`.

  #{ExDoppler.Doc.resources_block("workplace-logs#activity-logs", "activity_logs-object")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  alias ExDoppler.ActivityDiff
  alias ExDoppler.User

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

  @doc """
  Creates an `ActivityLog` from a map

  <!-- tabs-open -->
  ### Params
    * **activity_log**: Map of fields to turn into an `ActivityLog`

  #{ExDoppler.Doc.returns_block(success: "%ExDoppler.ActivityLog{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = activity_log) do
    fields =
      activity_log
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ActivityLog, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:user, val), do: User.build(val)
  defp serialize(:diff, val), do: ActivityDiff.build(val)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.ActivityDiff do
  @moduledoc """
  Module describing a `diff` to an `ExDoppler.ActivityLog`

  <!-- tabs-open -->
  ### Fields
    * `added` - Objects added in this Activity (e.g `["FOO_BAR"]`)
    * `removed` - Objects removed in this Activity (e.g `["NEW_SEC2"]`)
    * `updated` - Objects updated in this Activity (e.g `["HELLO_WORLD"]`)

  #{ExDoppler.Doc.resources_block("workplace-logs#activity-logs", "activity_logs-object")}

  <!-- tabs-close -->
  """

  import ExDoppler.Model

  defstruct [:added, :removed, :updated]

  @doc """
  Creates an `ActivityDiff` from a map

  <!-- tabs-open -->
  ### Params
    * **diff**: Map of fields to turn into an `ActivityDiff`

  #{ExDoppler.Doc.returns_block(success: "%ExDoppler.ActivityDiff{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = diff), do: struct(ExDoppler.ActivityDiff, prepare_keys(diff))
end
