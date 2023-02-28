defmodule ClusterFacadeTest do
  use ExUnit.Case
  doctest ClusterFacade

  test "greets the world" do
    assert ClusterFacade.hello() == :world
  end
end
