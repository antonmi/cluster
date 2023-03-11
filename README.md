# Cluster

https://www.poeticoding.com/connecting-elixir-nodes-with-libcluster-locally-and-on-kubernetes/
https://www.mendrugory.com/post/remote-elixir-node-kubernetes/
https://blog.erlware.org/epmdlessless/

### Run locally:
LOCAL=true iex --name app_a@127.0.0.1 -S mix
LOCAL=true iex --name app_b@127.0.0.1 -S mix

### docker-compose:
#### Remote shell inside a container:
docker-compose exec app-a1 bash
iex --name app_a@app-a1.docker  --cookie secret --remsh app-a1@app-a1.docker
or to other nodes
iex --name app_a@app-a1.docker  --cookie secret --remsh app-b1@app-b1.docker
#### From local
Modify /etc/hosts 
127.0.0.1       app-a1.docker
127.0.0.1       app-b1.docker
iex --cookie secret --name local@app-a1.docker --erl '-dist_listen false -erl_epmd_port 9000' --remsh app-a1@app-a1.docker
iex --cookie secret --name local@app-b1.docker --erl '-dist_listen false -erl_epmd_port 10000' --remsh app-b1@app-b1.docker

### Kubernetes:
check:
kubectl get service
minikube service load-balancer-service-a

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
iex --cookie secret --name local@app-a-0.beam-headless.default.svc.cluster.local --erl '-dist_listen false -erl_epmd_port 9000' --remsh cluster-app@app-a-0.beam-headless.default.svc.cluster.local



### Experiments
# connect to a node in container
Modify /etc/hosts
127.0.0.1       local.docker

Run container
docker run --hostname local.docker -it -p9000:9000 app-a bash
Run node
iex --cookie secret --name docker@local.docker --erl '-kernel inet_dist_listen_min 9000 inet_dist_listen_max 9000' -S mix
Locally
iex --cookie secret --name local@local.docker --erl '-dist_listen false -erl_epmd_port 9000' --remsh docker@local.docker

