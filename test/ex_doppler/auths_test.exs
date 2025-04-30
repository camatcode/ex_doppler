defmodule ExDoppler.AuthsTest do
  use ExUnit.Case
  doctest ExDoppler.Auths

  alias ExDoppler.Auths

  test "me/0" do
    assert {:ok, token_info} = Auths.me()
    assert token_info.slug
    assert token_info.created_at
    assert token_info.last_seen_at
    assert token_info.type
    assert token_info.token_preview
    assert token_info.workplace

    assert token_info.slug == Auths.me!().slug
  end
end
