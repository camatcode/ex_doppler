defmodule ExDoppler.WorkplaceUsers do
  @moduledoc false

  alias ExDoppler.Util.Requester
  alias ExDoppler.Workplaces

  defstruct [:access, :created_at, :id, :user]

  def workplace_users_api_path, do: Path.join(Workplaces.workplace_api_path(), "/users?")

  def list_workplace_users(opts \\ []) do
    opts = Keyword.merge([page: 1, email: nil], opts)

    workplace_users_api_path()
    |> Requester.get(qparams: [page: opts[:page], email: opts[:email]])
    |> case do
      {:ok, %{body: body}} ->
        page = body["page"]

        workplace_users = build_wp_users(body)

        resp = %{page: page, workplace_users: workplace_users}
        {:ok, resp}

      err ->
        err
    end
  end

  defp build_wp_users(body) do
    body["workplace_users"]
    |> Enum.map(fn wp_user ->
      fields =
        wp_user
        |> Enum.map(fn {key, val} ->
          key = String.to_atom(key)
          {key, serialize(key, val)}
        end)

      struct(ExDoppler.WorkplaceUser, fields)
    end)
  end

  defp serialize(:user, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.User, val)
  end

  defp serialize(_, val), do: val
end
