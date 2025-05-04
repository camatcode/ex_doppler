# SPDX-License-Identifier: Apache-2.0
defmodule ExDoppler.WorkplaceRoles do
  @moduledoc """
  Module for interacting with `ExDoppler.WorkplaceRole`

  <!-- tabs-open -->

  #{ExDoppler.Doc.resources("custom-roles", "workplace_roles-list")}

  <!-- tabs-close -->
  """

  alias ExDoppler.Requester
  alias ExDoppler.WorkplaceRole

  @workplace_roles_api_path "/v3/workplace/roles"

  @doc """
  Lists `ExDoppler.WorkplaceRole`

  <!-- tabs-open -->

  #{ExDoppler.Doc.returns(success: "{:ok, [%ExDoppler.WorkplaceRole{...} ...]}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.WorkplaceRoles
      iex> {:ok, _roles} = WorkplaceRoles.list_workplace_roles()

  #{ExDoppler.Doc.resources("workplace_roles-list")}

  <!-- tabs-close -->
  """
  def list_workplace_roles do
    with {:ok, %{body: body}} <- Requester.get(@workplace_roles_api_path) do
      roles =
        body["roles"]
        |> Enum.map(&WorkplaceRole.build/1)

      {:ok, roles}
    end
  end

  @doc """
  Same as `list_workplace_roles/0` but won't wrap a successful response in `{:ok, response}`
  """
  def list_workplace_roles! do
    with {:ok, roles} <- list_workplace_roles() do
      roles
    end
  end

  @doc """
  Retrieves a `ExDoppler.WorkplaceRole`, given a project and a webhook id

  <!-- tabs-open -->

  ### 🏷️ Params
    * **id** - ID of the role to retrieve

  #{ExDoppler.Doc.returns(success: "{:ok, %ExDoppler.WorkplaceRole{...}}", failure: "{:error, err}")}

  ### 💻 Examples

      iex> alias ExDoppler.WorkplaceRoles
      iex> {:ok, _role} = WorkplaceRoles.get_workplace_role("owner")

  #{ExDoppler.Doc.resources("workplace_roles-get")}

  <!-- tabs-close -->
  """
  def get_workplace_role(identifier) when is_bitstring(identifier) do
    path =
      @workplace_roles_api_path
      |> Path.join("/role/#{identifier}")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, WorkplaceRole.build(body["role"])}
    end
  end

  @doc """
  Same as `get_workplace_role/1` but won't wrap a successful response in `{:ok, response}`
  """
  def get_workplace_role!(identifier) do
    with {:ok, role} <- get_workplace_role(identifier) do
      role
    end
  end
end
