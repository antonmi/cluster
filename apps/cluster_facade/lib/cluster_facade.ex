defmodule ClusterFacade do
  use GenServer

  def init(opts) do
    {:ok, opts}
  end

  def service_name do
    Application.get_env(:cluster_facade, :service_name)
  end
end
