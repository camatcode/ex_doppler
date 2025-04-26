defmodule ExDoppler.WorkplaceUsers do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @workplace_users_api_path "v3/workplace/users"

  def list_workplace_users(opts \\ []) do
    opts = Keyword.merge([page: 1, email: nil], opts)

    with {:ok, %{body: body}} <- Requester.get(@workplace_users_api_path, qparams: opts) do
      page = body["page"]

      workplace_users =
        body["workplace_users"]
        |> Enum.map(&build_wp_user/1)

      {:ok, %{page: page, workplace_users: workplace_users}}
    end
  end

  def get_workplace_user(id) when not is_nil(id) do
    path =
      @workplace_users_api_path
      |> Path.join("/#{id}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, build_wp_user(body["workplace_user"])}
    end
  end

  defp build_wp_user(wp_user) do
    fields =
      wp_user
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.WorkplaceUser, fields)
  end

  defp serialize(:user, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.User, val)
  end

  defp serialize(_, val), do: val
end
