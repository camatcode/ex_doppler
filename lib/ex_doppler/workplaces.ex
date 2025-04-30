defmodule ExDoppler.Workplaces do
  @moduledoc """
  Module for interacting with `ExDoppler.Workplace`
  """

  alias ExDoppler.Util.Requester
  alias ExDoppler.Workplace

  @workplace_api_path "/v3/workplace"

  @doc """
  Retrieves a `ExDoppler.Workplace`, given options

  <!-- tabs-open -->

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Workplace{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/workplace-get){:target="_blank"}
  <!-- tabs-close -->
  """
  def get_workplace do
    with {:ok, %{body: body}} <- Requester.get(@workplace_api_path) do
      {:ok, Workplace.build(body["workplace"])}
    end
  end

  @doc """
  Same as `get_workplace/0` but won't wrap a successful response in `{:ok, response}`
  """
  def get_workplace! do
    with {:ok, wp} <- get_workplace() do
      wp
    end
  end

  @doc """
  Updates an `ExDoppler.Workplace`, given options detailing modifications

  <!-- tabs-open -->


  ### Params
    * **opts**: Optional modifications
      * **billing_email** - New billing email for the workplace
      * **security_email** - New security email for the workplace

  ### Returns

    **On Success**

    ```elixir
    {:ok, %ExDoppler.Workplace{...}}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/workplace-update){:target="_blank"}
  """
  def update_workplace(opts \\ []) do
    {:ok, workplace} = get_workplace()

    opts = [
      json: %{
        name: workplace.name,
        billing_email: opts[:billing_email] || workplace.billing_email,
        security_email: opts[:security_email] || workplace.security_email
      }
    ]

    with {:ok, %{body: body}} <- Requester.post(@workplace_api_path, opts) do
      {:ok, Workplace.build(body["workplace"])}
    end
  end

  @doc """
  Same as `update_workplace/1` but won't wrap a successful response in `{:ok, response}`
  """
  def update_workplace!(opts \\ []) do
    with {:ok, wp} <- update_workplace(opts) do
      wp
    end
  end

  @doc """
  Lists permissions known in `ExDoppler.Workplace`

  <!-- tabs-open -->

  ### Returns

    **On Success**

    ```elixir
    {:ok, ["perm1"...]}
    ```

    **On Failure**

     ```elixir
    {:err, err}
    ```

  ### Resources

    * See relevant [Doppler API docs](https://docs.doppler.com/reference/workplace_roles-list_permissions){:target="_blank"}
  """
  def list_permissions do
    path = Path.join(@workplace_api_path, "/permissions")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, body["permissions"]}
    end
  end

  @doc """
  Same as `list_permissions/0` but won't wrap a successful response in `{:ok, response}`
  """
  def list_permissions! do
    with {:ok, permissions} <- list_permissions() do
      permissions
    end
  end
end
