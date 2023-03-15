import Config

cond do
  System.get_env("LIBCLUSTER_STRATEGY") == "local_epmd" ->
    config :libcluster,
      topologies: [
        local_epmd: [
          strategy: Cluster.Strategy.LocalEpmd
        ]
      ]

  System.get_env("LIBCLUSTER_STRATEGY") == "gossip" ->
    config :libcluster,
      topologies: [
        gossip: [
          strategy: Cluster.Strategy.Gossip
        ]
      ]

  System.get_env("LIBCLUSTER_STRATEGY") == "kubernetes" ->
    config :libcluster,
      topologies: [
        k8s: [
          strategy: Cluster.Strategy.Kubernetes,
          config: [
            mode: :hostname,
            kubernetes_ip_lookup_mode: :pods,
            kubernetes_service_name: "beam-cluster",
            kubernetes_node_basename: "cluster-app",
            kubernetes_selector: "cluster=beam"
          ]
        ]
      ]

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

  true ->
    config :libcluster, topologies: []
end
