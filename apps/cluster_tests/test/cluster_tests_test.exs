defmodule ClusterTestsTest do
  use ExUnit.Case

  test "greets the world" do
    [node_a1, node_a2, node_a3] = LocalCluster.start_nodes("app_a", 3, applications: [ :app_a])

    [node_b1, node_b2, node_b3] = LocalCluster.start_nodes("app_b", 3, applications: [ :app_b])

    IO.inspect(:rpc.call(node_a1, Node, :list, []))
    IO.inspect(:rpc.call(node_a1, NodeRegistry, :all, []))
    IO.inspect(:rpc.call(node_a2, NodeRegistry, :all, []))
  end
end
