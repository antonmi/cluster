# Cluster

https://www.poeticoding.com/connecting-elixir-nodes-with-libcluster-locally-and-on-kubernetes/
https://www.mendrugory.com/post/remote-elixir-node-kubernetes/
https://blog.erlware.org/epmdlessless/

### Run locally:
LOCAL=true iex --name app_a@127.0.0.1 -S mix
LOCAL=true iex --name app_b@127.0.0.1 -S mix

### Connect in docker container, when running with docker-compose:
docker-compose exec app-a2 sh
iex --sname app_a_console --cookie secret -S mix

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
kubectl exec app-a-7f7d9d9f4b-4j2xg -it sh
START_SERVER=false iex --name app_a@127.0.0.1 --cookie secret -S mix
