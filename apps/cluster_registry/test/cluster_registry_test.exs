defmodule ClusterRegistryTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = ClusterRegistry.start_link(:service_a)

    on_exit(fn ->
      :global.unregister_name(:service_a)
    end)

    %{pid: pid}
  end

  test "check :global.registered_names()", %{pid: pid} do
    assert :global.registered_names() == [:service_a]
    assert :global.whereis_name(:service_a) == pid
  end

  test "state", %{pid: pid} do
    assert ClusterRegistry.state() == %ClusterRegistry{
             node: :nonode@nohost,
             name: :service_a,
             pid: pid
           }
  end

  test "test getters" do
    assert ClusterRegistry.node_with_name(:service_a) == :nonode@nohost
    assert ClusterRegistry.random_node_with_prefix(:serv) == :nonode@nohost
    assert ClusterRegistry.all_nodes_with_prefix(:serv) == [:nonode@nohost]
    assert ClusterRegistry.node_with_name(:no_such_service) == nil
  end

  test "info/1", %{pid: pid} do
    assert ClusterRegistry.info(:nonode@nohost) == %ClusterRegistry{
             node: :nonode@nohost,
             name: :service_a,
             pid: pid
           }
  end

  test "list/0", %{pid: pid} do
    assert ClusterRegistry.list() == [
             %ClusterRegistry{
               node: :nonode@nohost,
               name: :service_a,
               pid: pid
             }
           ]
  end
end
