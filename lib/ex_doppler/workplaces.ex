defmodule ExDoppler.Workplaces do
  @moduledoc false

  alias ExDoppler.Util.Requester
  alias ExDoppler.Workplace

  @workplace_api_path "/v3/workplace"

  def get_workplace(opts \\ []) do
    with {:ok, %{body: body}} <- Requester.get(@workplace_api_path, opts) do
      {:ok, Workplace.build(body["workplace"])}
    end
  end

  def get_workplace!(opts \\ []) do
    with {:ok, wp} <- get_workplace(opts) do
      wp
    end
  end

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

  def list_permissions do
    path = Path.join(@workplace_api_path, "/permissions")

    with {:ok, %{body: body}} <- Requester.get(path) do
      {:ok, body["permissions"]}
    end
  end

  def list_permissions! do
    with {:ok, permissions} <- list_permissions() do
      permissions
    end
  end
end
