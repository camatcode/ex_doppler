defmodule ExDoppler.Invites do
  @moduledoc false

  alias ExDoppler.Util.Requester

  @invites_api_path "/v3/workplace/invites"

  def list_invites(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@invites_api_path, qparams: opts) do
      invites =
        body["invites"]
        |> Enum.map(&build_invite/1)

      {:ok, invites}
    end
  end

  defp build_invite(invite) do
    fields =
      invite
      |> Enum.map(fn {key, val} ->
        key = String.to_atom(key)
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.Invite, fields)
  end

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
