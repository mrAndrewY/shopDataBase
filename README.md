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

### Create configMap for init db 

    kubectl create configmap init-sql --from-file=init.sql

Check configMap in any of following ways:

    kubectl get configmap
    kubectl describe configmaps init-sql
    kubectl get configmaps init-sql -o yaml

### Start postgres pods

    kubectl apply -f db_deployment.yaml

- Check start pod
  ```
  kubectl get pods
  ```
- Check file exist for init db
  ```
  kubectl exec -it <pod-name> -- ls /docker-entrypoint-initdb.d
  ```
- Read logs
  ```
  kubectl logs <pod-name>
  ```
- Access to db
  ```
  kubectl exec -it <pod-name> -- psql -U postgres -d postgres
  ```
  and simple query
  ```
  SELECT * FROM shop.step;
  ```

### Start ingress

    kubectl apply -f ingress.yaml

### Uninstall

- Delete deployments
  ```
  kubectl delete deployments --all
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