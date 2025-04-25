defmodule ExDopplerTest do
  use ExUnit.Case
  doctest ExDoppler

  test "greets the world" do
    assert ExDoppler.hello() == :world
  end
end
