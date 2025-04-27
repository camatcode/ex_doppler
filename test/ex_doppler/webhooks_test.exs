defmodule ExDoppler.WebhooksTest do
  use ExUnit.Case
  doctest ExDoppler.Webhooks

  alias ExDoppler.Webhooks

  test "Webhooks" do
    assert {:ok, _webhooks} = Webhooks.list_webhooks()
  end
end
