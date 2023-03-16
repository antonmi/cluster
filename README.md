# Cluster

## Experiment with clustering. Check the [Medium article](https://anton-mishchuk.medium.com/notes-on-clustering-elixir-applications-49707ed53910)

### Run locally:
START_SERVER=true iex --name app_a@127.0.0.1 --cookie secret -S mix
START_SERVER=true iex --name app_b@127.0.0.1 --cookie secret -S mix
Node.connect(:"app_b@127.0.0.1")

Start with server:


#### With Cluster.Strategy.LocalEpmd 
LIBCLUSTER_STRATEGY=local_epmd iex --name app_a@127.0.0.1 --cookie secret -S mix
LIBCLUSTER_STRATEGY=local_epmd iex --name app_b@127.0.0.1 --cookie secret -S mix

### docker-compose:
#### From local
Modify /etc/hosts 
127.0.0.1       app-a1.docker
127.0.0.1       app-b1.docker
iex --name local@app-a1.docker --cookie secret --erl '-dist_listen false -erl_epmd_port 9000' --remsh app-a1@app-a1.docker
iex --name local@app-b1.docker --cookie secret --erl '-dist_listen false -erl_epmd_port 10000' --remsh app-b1@app-b1.docker

### Kubernetes:
check:
kubectl get service
minikube service app-a

restart:
kubectl get deployment
kubectl delete deployment app-a-deployment
kubectl delete deployment app-b-deployment
kubectl apply -f k8s

rebuild containers:
eval $(minikube -p minikube docker-env)
docker build -t app-a .
docker build -t app-b .

Connect to cluster:
Modify /etc/hosts
127.0.0.1       app-a-0.beam-headless.default.svc.cluster.local
iex --cookie secret --name local@app-a-0.beam-cluster.default.svc.cluster.local --erl '-dist_listen false -erl_epmd_port 9000' --remsh app-a@app-a-0.beam-cluster.default.svc.cluster.local
