import Config

cond do
  System.get_env("IN_K8S") == "true" ->
    config :libcluster,
      topologies: [
        k8s_example: [
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
        epmd: [
          strategy: Cluster.Strategy.LocalEpmd
        ]
      ]

  true ->
    config :libcluster,
      topologies: [
        epmd: [
          strategy: Cluster.Strategy.Epmd,
          config: [
            hosts: [
              :"app-a@172.16.238.11",
              :"app-a@172.16.238.12",
              :"app-a@172.16.238.13",
              :"app-b@172.16.238.21",
              :"app-b@172.16.238.22",
              :"app-b@172.16.238.23"
            ]
          ]
        ]
      ]
end

config :cluster_facade, service_name: :app_a
