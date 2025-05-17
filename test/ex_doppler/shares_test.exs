defmodule ExDoppler.SharesTest do
  use ExUnit.Case

  alias ExDoppler.Shares

  doctest ExDoppler.Shares

  test "plain_text/2" do
    share_text = String.replace(Faker.Internet.domain_word(), "_", "-")

    {:ok, share} = Shares.plain_text(share_text)
    assert share.url
    assert share.authenticated_url
    assert share.password
  end
end
