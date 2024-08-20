# Shop DataBase

## Init database in kubernetes

---

### Running local Kubernetes clusters

Install `kind` according to the instructions on the website https://kind.sigs.k8s.io/

Check if `kubectl` is installed

    kubectl version

Create cluster

    kind create cluster --config kind-config.yaml

Install Ingress Controller for NGINX in cluster Kubernetes

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

Automate deployment and check the health of Kubernetes cluster components after installing Ingress Controller.

    kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

### Add namespace `shop`

    kubectl apply -f shop_namespace.yml

or 

    kubectl create namespace shop 

### Create configMap for init db 

    kubectl create configmap init-sql --from-file=init.sql -n shop

Check configMap in any of following ways:

    kubectl get configmap
    kubectl describe configmaps init-sql
    kubectl get configmaps init-sql -o yaml

### Start postgres pods

    kubectl apply -f db_deployment.yaml

- Check start pod
  ```
  kubectl get pods -n shop
  ```
- Check file exist for init db
  ```
  kubectl exec -it <pod-name> -n shop -- ls /docker-entrypoint-initdb.d
  ```
- Read logs
  ```
  kubectl logs <pod-name> -n shop
  ```
- Access to db
  ```
  kubectl exec -it <pod-name> -n shop -- psql -U postgres -d postgres
  ```
  and simple query
  ```
  SELECT * FROM shop.step;
  ```
- Access to db port-forwarding
  ```
  kubectl port-forward service/shop-database 5432:5432 -n shop
  ```

### Start ingress

    kubectl apply -f ingress.yaml

### Deployment Zookeeper

    kubectl apply -f zookeeper-deployment.yaml

### Deployment Kafka

    kubectl apply -f kafka-deployment.yaml

- Create test topic
  ```
  kubectl exec -it <kafka-pod-name> -n shop -- /opt/kafka/bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092
  ```
- Test Kafka producer
  ```
  kubectl exec -it <kafka-pod-name> -n shop -- /opt/kafka/bin/kafka-console-producer.sh --topic test-topic --bootstrap-server localhost:9092
  ```
- Test Kafka consumer in another terminal
  ```
  kubectl exec -it <kafka-pod-name> -n shop -- /opt/kafka/bin/kafka-console-consumer.sh --topic test-topic --from-beginning --bootstrap-server localhost:9092
  ```

### Show all

    kubectl get -n shop all -o wide

### Uninstall

- Delete deployments
  ```
  kubectl delete deployments --all
  ```
- Delete services
  ```
  kubectl delete service --all
  ```
- Delete ingress
  ```
  kubectl delete ingress --all
  ```
- Delete configMap
  ```
  kubectl delete configmap init-sql
  ```
- Delete cluster
  ```
  kind delete cluster
  ```