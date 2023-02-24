import Config

if System.get_env("IN_K8S") do
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
else
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
