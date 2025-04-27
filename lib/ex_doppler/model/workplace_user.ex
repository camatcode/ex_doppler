defmodule ExDoppler.WorkplaceUser do
  @moduledoc false
  defstruct [:access, :created_at, :id, :user]
  import ExDoppler.Model

  def build(wp_user) do
    fields =
      wp_user
      |> atomize_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.WorkplaceUser, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:user, val), do: struct(ExDoppler.User, atomize_keys(val))
  defp serialize(_, val), do: val
end

defmodule ExDoppler.User do
  @moduledoc false
  defstruct [:email, :name, :profile_image_url, :username]
end
