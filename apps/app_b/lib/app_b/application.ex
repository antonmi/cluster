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
      {Cluster.Supervisor, [topologies, [name: AppB.ClusterSupervisor]]},
      {NodeRegistry, "app_b_#{postfix()}"}
    ]

    children =
      if start_server?() do
        [{Plug.Cowboy, scheme: :http, plug: AppB.Router, options: [port: port()]} | children]
      else
        children
      end

    opts = [strategy: :one_for_one, name: AppB.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port do
    (System.get_env("PORT") || "5001")
    |> String.to_integer()
  end

  defp start_server? do
    System.get_env("START_SERVER") == "true"
  end

  defp postfix do
    System.get_env("POSTFIX") || random_string()
  end

  defp random_string do
    :crypto.strong_rand_bytes(5) |> Base.encode32()
  end
end
