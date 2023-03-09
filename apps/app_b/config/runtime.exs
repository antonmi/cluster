import Config

cond do
  System.get_env("LIBCLUSTER_STRATEGY") == "kubernetes.dns" ->
    config :libcluster,
           topologies: [
             k8s_dns: [
               strategy: Cluster.Strategy.Kubernetes.DNS,
               config: [
                 service: "beam-cluster",
                 application_name: "cluster-app"
               ]
             ]
           ]

  System.get_env("LIBCLUSTER_STRATEGY") == "gossip" ->
    config :libcluster,
           topologies: [
             gossip: [
               strategy: Cluster.Strategy.Gossip
             ]
           ]

  System.get_env("LOCAL") == "true" ->
    config :libcluster,
           topologies: [
             local_epmd: [
               strategy: Cluster.Strategy.LocalEpmd
             ]
           ]

  true ->
    if Mix.env() == :test do
      config :libcluster, topologies: []
    else
      raise "LIBCLUSTER_STRATEGY is not set"
    end
end
