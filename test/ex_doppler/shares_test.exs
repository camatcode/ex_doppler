defmodule ExDoppler.SharesTest do
  use ExUnit.Case
  doctest ExDoppler.Shares

  alias ExDoppler.Shares

  test "plain_text/2" do
    share_text = Faker.Internet.domain_word() |> String.replace("_", "-")

    {:ok, share} = Shares.plain_text(share_text)
    assert share.url
    assert share.authenticated_url
    assert share.password
  end
end
