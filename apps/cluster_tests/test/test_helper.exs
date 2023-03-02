:ok = LocalCluster.start()

Application.ensure_all_started(:cluster_tests)

ExUnit.start()
