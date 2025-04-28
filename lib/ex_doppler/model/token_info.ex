defmodule ExDoppler.TokenInfo do
  @moduledoc false

  import ExDoppler.Model

  alias ExDoppler.Workplace

  defstruct [:slug, :name, :created_at, :last_seen_at, :type, :token_preview, :workplace]

  def build(%{} = token_info) do
    fields =
      token_info
      |> prepare_keys()
      |> Enum.map(fn {key, val} ->
        {key, serialize(key, val)}
      end)

    struct(ExDoppler.TokenInfo, fields)
  end

  defp serialize(_, nil), do: nil
  defp serialize(:workplace, val), do: Workplace.build(val)
  defp serialize(_, val), do: val
end

defmodule ExDoppler.ODICToken do
  @moduledoc false

  import ExDoppler.Model

  defstruct [:token, :expires_at]

  def build(%{} = odic_token), do: struct(ExDoppler.ODICToken, prepare_keys(odic_token))
end
