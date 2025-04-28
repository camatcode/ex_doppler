defmodule ExDoppler.WorkplaceUser do
  @moduledoc false
  defstruct [:access, :created_at, :id, :user]
  import ExDoppler.Model

  alias ExDoppler.User

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
  @moduledoc false
  import ExDoppler.Model

  defstruct [:email, :name, :profile_image_url, :username]

  def build(%{} = user), do: struct(ExDoppler.User, prepare_keys(user))
end
