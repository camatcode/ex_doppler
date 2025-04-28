defmodule ExDoppler.Invites do
  @moduledoc false

  alias ExDoppler.Invite
  alias ExDoppler.Util.Requester

  @invites_api_path "/v3/workplace/invites"

  def list_invites(opts \\ []) do
    opts = Keyword.merge([page: 1, per_page: 20], opts)

    with {:ok, %{body: body}} <- Requester.get(@invites_api_path, qparams: opts) do
      invites =
        body["invites"]
        |> Enum.map(&Invite.build/1)

      {:ok, invites}
    end
  end

  def list_invites!(opts \\ []) do
    with {:ok, invites} <- list_invites(opts) do
      invites
    end
  end
end
