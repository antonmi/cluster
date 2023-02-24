defmodule AppB.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)
    Logger.info("topologies: #{inspect(topologies)}")

    children = [
      {Plug.Cowboy, scheme: :http, plug: AppB.Router, options: [port: port()]},
      {Cluster.Supervisor, [topologies, [name: AppB.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AppB.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port() do
    (System.get_env("PORT") || "4001")
    |> String.to_integer()
  end
end
