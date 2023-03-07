import Config

cond do
  System.get_env("IN_K8S") == "true" ->
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

  System.get_env("LOCAL") == "true" ->
    config :libcluster,
      topologies: [
        local_epmd: [
          strategy: Cluster.Strategy.LocalEpmd
        ]
      ]

  true -> # docker-compose
    config :libcluster,
      topologies: [
        gossip: [
          strategy: Cluster.Strategy.Gossip
        ]
      ]
end
