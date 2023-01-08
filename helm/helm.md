## Canasta Helm

### Installation (General)
First, make sure you have a Kubernetes cluster ready, and that Kubectl works.

Then, clone the repository:
```shell
git clone https://github.com/CanastaWiki/Canasta.git
```

### Installation (Helm)
First, make sure that you have Helm installed. If not, go to: https://helm.sh/docs/intro/install/

Start the Helm installation: 
```shell
helm install canasta helm/
```

Check for the installation:
```shell
kubectl get all
```

### Update the Helm chart (with new changes)
If you modify/upgrade something, you can spin up the changes in current deployment
```shell
helm upgrade --install canasta helm/
```

### Uninstall
To uninstall the Helm chart:
```shell
helm uninstall canasta
```
