defmodule ClusterTestsTest do
  use ExUnit.Case

  test "greets the world" do
    Application.put_env(:cluster_facade, :service_name, :app_a)
    [node_a1, node_a2, node_a3] = LocalCluster.start_nodes("app_a", 3, applications: [ :app_a])

    Application.put_env(:cluster_facade, :service_name, :app_b)
    [node_b1, node_b2, node_b3] = LocalCluster.start_nodes("app_b", 3, applications: [ :app_b])

    IO.inspect(:rpc.call(node_a1, Node, :list, []))
    IO.inspect(:rpc.call(node_a1, ClusterFacade, :service_name, []))
    IO.inspect(:rpc.call(node_a2, ClusterFacade, :service_name, []))
  end
end
