defmodule ExDoppler.Model do
  def atomize_keys(m) do
    m
    |> Enum.map(fn {key, val} ->
      key = String.to_atom(key)
      {key, val}
    end)
  end
end

defmodule ExDoppler.DefaultWorkplaceRole do
  @moduledoc false
  defstruct [:identifier]
end

defmodule ExDoppler.ServiceToken do
  @moduledoc false
  defstruct [:name, :slug, :created_at, :config, :environment, :project, :expires_at]

  def build_service_token(token) do
    fields =
      token
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.ServiceToken, fields)
  end
end

defmodule ExDoppler.Invite do
  @moduledoc false
  defstruct [:slug, :email, :created_at, :workplace_role]

  def build_invite(invite) do
    fields =
      invite
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Invite, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:workplace_role, val) do
    val =
      val
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.WorkplaceRole, val)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.ServiceAccount do
  @moduledoc false
  defstruct [:name, :slug, :created_at, :workplace_role]

  def build_service_account(account) do
    fields =
      account
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.ServiceAccount, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:workplace_role, val) do
    val =
      val
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, val}
      end)

    struct(ExDoppler.WorkplaceRole, val)
  end

  defp serialize(_, val), do: val
end

defmodule ExDoppler.TokenInfo do
  @moduledoc false
  defstruct [:slug, :name, :created_at, :last_seen_at, :type, :token_preview, :workplace]

  def build_token_info(token_info) do
    fields =
      token_info
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.TokenInfo, fields)
  end

  defp serialize(_, nil), do: nil

  defp serialize(:workplace, val) do
    val =
      val
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)

    struct(ExDoppler.Workplace, val)
  end

  defp serialize(_, val), do: val
end
