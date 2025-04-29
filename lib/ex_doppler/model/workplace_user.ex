defmodule ExDoppler.WorkplaceUser do
  @moduledoc """
  Module describing a Doppler [WorkplaceUser](https://docs.doppler.com/reference/users-list)

  ### Fields
    * `access` - level of access this WorkplaceUser has (e.g `"owner"`, `"collaborator"`, or `"admin"`)
    * `created_at` - DateTime for when this user was created (e.g `"2025-04-28T16:09:17.737Z"`)
    * `id` - Unique Identifier for this user (e.g `"00000000-0000-0000-0000-000000000000"`)
    * `user` - More details for this user. See `ExDoppler.User`.
  """
  defstruct [:access, :created_at, :id, :user]
  import ExDoppler.Model

  alias ExDoppler.User

  @doc """
  Creates an `WorkplaceUser` from a map

  ### Params
    * **wp_user**: Map of fields to turn into an `User`
  """
  def build(%{} = wp_user) do
    fields =
      wp_user
      |> prepare_keys()
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

  ### Fields
    * `email` - User's email (e.g `"jane.smith@example.com"`)
    * `name` - User's name (e.g `"Jane Smith"`)
    * `profile_image_url` - URL to a profile image
    * `username` - User's username (e.g `"jsmith"`)
  """
  import ExDoppler.Model

  defstruct [:email, :name, :profile_image_url, :username]

  @doc """
  Creates an `User` from a map

  ### Params
    * **user**: Map of fields to turn into an `User`
  """
  def build(%{} = user), do: struct(ExDoppler.User, prepare_keys(user))
end
