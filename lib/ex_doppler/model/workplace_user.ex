# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.WorkplaceUser do
  @moduledoc """
  Module describing a WorkplaceUser

  <!-- tabs-open -->
  ### Fields
    * `access` - level of access this WorkplaceUser has (e.g `"owner"`, `"collaborator"`, or `"admin"`)
    * `created_at` - DateTime for when this user was created (e.g `~U[2025-04-30 10:05:50.040Z]`)
    * `id` - Unique Identifier for this user (e.g `"00000000-0000-0000-0000-000000000000"`)

  #{ExDoppler.Doc.resources("workplace-team#user-management", "users-list")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  alias ExDoppler.User

  defstruct [:access, :created_at, :id, :user]

  @doc """
  Creates an `WorkplaceUser` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **wp_user**: Map of fields to turn into an `User`

  <!-- tabs-close -->
  """
  def build(%{} = wp_user) do
    fields =
      wp_user
      |> prepare()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.WorkplaceUser, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:user, val), do: User.build(val)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.User do
  @moduledoc """
  Module describing a Doppler User (not to be confused with `ExDoppler.WorkplaceUser`)

  <!-- tabs-open -->
  ### Fields
    * `email` - User's email (e.g `"jane.smith@example.com"`)
    * `name` - User's name (e.g `"Jane Smith"`)
    * `profile_image_url` - URL to a profile image
    * `username` - User's username (e.g `"jsmith"`)

  #{ExDoppler.Doc.resources("workplace-team#user-management", "users-list")}

  <!-- tabs-close -->
  """
  import ExDoppler.Model

  defstruct [:email, :name, :profile_image_url, :username]

  @doc """
  Creates an `User` from a map

  <!-- tabs-open -->
  ### 🏷️ Params
    * **user**: Map of fields to turn into an `User`

  #{ExDoppler.Doc.returns(success: "%ExDoppler.User{...}", failure: "raise Error")}

  <!-- tabs-close -->
  """
  def build(%{} = user), do: struct(ExDoppler.User, prepare(user))
end
