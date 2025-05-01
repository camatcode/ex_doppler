# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.WorkplaceUsers do
  @moduledoc """
  Module for interacting with `ExDoppler.WorkplaceUser`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("workplace-team#user-management", "users-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Requester
  alias ExDoppler.WorkplaceUser

  @workplace_users_api_path "v3/workplace/users"

  @doc """
  Lists `ExDoppler.WorkplaceUser` using pagination.

  <!-- tabs-open -->

  ### 🏷️ Params
    * **opts**: Optional modifications to the list call
      * **page** - which page to list (starts at 1) (e.g `page: 2`). Default: `1`
      * **email** - Filter results to only include the user with the provided email address. Default: `nil`

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.WorkplaceUser{...} ...]}", failure: "{:err, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.WorkplaceUsers
      iex> {:ok, _users} = WorkplaceUsers.list_workplace_users()

  #{ExDoppler.Doc.resources("users-list")}

  <!-- tabs-close -->
  """
  def list_workplace_users(opts \\ []) do
    opts = Keyword.merge([page: 1, email: nil], opts)

    with {:ok, %{body: body}} <- Requester.get(@workplace_users_api_path, qparams: opts) do
      workplace_users =
        body["workplace_users"]
        |> Enum.map(&WorkplaceUser.build/1)

      {:ok, workplace_users}
    end
  end

  @doc """
  Same as `list_workplace_users/1` but won't wrap a successful response in `{:ok, response}`
  """
  def list_workplace_users!(opts \\ []) do
    with {:ok, wp_users} <- list_workplace_users(opts) do
      wp_users
    end
  end

  @doc """
  Retrieves a `ExDoppler.WorkplaceUser`, given a project and a webhook id

  <!-- tabs-open -->

  ### 🏷️ Params
    * **id** - ID of the Workplace User to retrieve

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.WorkplaceUser{...}}", failure: "{:err, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.WorkplaceUsers
      iex> {:ok, [user | _]} = WorkplaceUsers.list_workplace_users()
      iex> {:ok, _user} = WorkplaceUsers.get_workplace_user(user.id)

  #{ExDoppler.Doc.resources("users-get")}

  <!-- tabs-close -->
  """
  def get_workplace_user(id) when is_bitstring(id) do
    path =
      @workplace_users_api_path
      |> Path.join("/#{id}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, WorkplaceUser.build(body["workplace_user"])}
    end
  end

  @doc """
  Same as `get_workplace_user/1` but won't wrap a successful response in `{:ok, response}`
  """
  def get_workplace_user!(id) do
    with {:ok, wp_user} <- get_workplace_user(id) do
      wp_user
    end
  end

  @doc """
  Updates an `ExDoppler.WorkplaceUser`, given a workplace user and new access

  <!-- tabs-open -->

  ### 🏷️ Params
    * **workplace_user**: The relevant environment (e.g `%WorkplaceUser{id: "98370f9a-0675-430a-abbc-dbb02b78c5a8" ...}`)
    * **new_access**: E.g., `:owner`, `:collaborator`, etc.

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.WorkplaceUser{...}}", failure: "{:err, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.WorkplaceUsers
      iex> {:ok, [user | _]} = WorkplaceUsers.list_workplace_users()
      iex> {:ok, _user} = WorkplaceUsers.update_workplace_user(user, :owner)

  #{ExDoppler.Doc.resources("users-update")}

  <!-- tabs-close -->
  """
  def update_workplace_user(%WorkplaceUser{id: id}, new_access)
      when is_bitstring(new_access) or is_atom(new_access) do
    path =
      @workplace_users_api_path
      |> Path.join("/#{id}")

    opts = [json: %{access: new_access}]

    with {:ok, %{body: body}} <- Requester.patch(path, opts) do
      {:ok, WorkplaceUser.build(body["workplace_user"])}
    end
  end

  @doc """
  Same as `update_workplace_user/1` but won't wrap a successful response in `{:ok, response}`
  """
  def update_workplace_user!(%WorkplaceUser{} = wp_user, new_access) do
    with {:ok, wp_user} <- update_workplace_user(wp_user, new_access) do
      wp_user
    end
  end
end
