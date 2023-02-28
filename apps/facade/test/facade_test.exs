defmodule FacadeTest do
  use ExUnit.Case
  doctest Facade

  test "greets the world" do
    assert Facade.hello() == :world
  end
end
