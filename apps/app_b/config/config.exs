import Config

# config :libcluster,
#  topologies: [
#    example: [
#      strategy: Cluster.Strategy.LocalEpmd,
#    ]
#  ]

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
