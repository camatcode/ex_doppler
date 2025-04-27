defmodule ExDoppler.SharesTest do
  use ExUnit.Case
  doctest ExDoppler.Shares

  alias ExDoppler.Shares

  test "Shares" do
    {:ok, share} = Shares.plain_text("SHARING_THIS")
    assert share.url
    assert share.authenticated_url
    assert share.password
  end
end
