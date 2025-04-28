defmodule ExDoppler.WorkplaceUsers do
  @moduledoc false

  alias ExDoppler.Util.Requester
  alias ExDoppler.WorkplaceUser

  @workplace_users_api_path "v3/workplace/users"

  def list_workplace_users(opts \\ []) do
    opts = Keyword.merge([page: 1, email: nil], opts)

    with {:ok, %{body: body}} <- Requester.get(@workplace_users_api_path, qparams: opts) do
      page = body["page"]

      workplace_users =
        body["workplace_users"]
        |> Enum.map(&WorkplaceUser.build/1)

      {:ok, %{page: page, workplace_users: workplace_users}}
    end
  end

  def list_workplace_users!(opts \\ []) do
    with {:ok, wp_users} <- list_workplace_users(opts) do
      wp_users
    end
  end

  def get_workplace_user(id) when is_bitstring(id) do
    path =
      @workplace_users_api_path
      |> Path.join("/#{id}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, WorkplaceUser.build(body["workplace_user"])}
    end
  end

  def get_workplace_user!(id) do
    with {:ok, wp_user} <- get_workplace_user(id) do
      wp_user
    end
  end

  def update_workplace_user(%WorkplaceUser{id: id}, new_access) do
    path =
      @workplace_users_api_path
      |> Path.join("/#{id}")

    opts = [json: %{access: new_access}]

    with {:ok, %{body: body}} <- Requester.patch(path, opts) do
      {:ok, WorkplaceUser.build(body["workplace_user"])}
    end
  end
end
