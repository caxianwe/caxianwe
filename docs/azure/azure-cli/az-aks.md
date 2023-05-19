# Manage Azure Kubernetes Services

## az aks

```powershell
# Sign in with the Azure CLI
az login --service-principal --username $applicationId --password $clientSecret --tenant $tenantId --allow-no-subscriptions
```

```powershell
# Set a subscription to be the current active subscription
az account set --subscription $subscription
```

```powershell
# Create a new resource group
az group create --location $location --name $resourceGroup
```

```powershell
# Create a new managed Kubernetes cluster
az aks create --name $managedCluster --resource-group $resourceGroup --service-principal $applicationId --client-secret $clientSecret --generate-ssh-keys
```

```powershell
# Get access credentials for a managed Kubernetes cluster
az aks get-credentials --name $managedCluster --resource-group $resourceGroup --overwrite-existing
```

## az acr

```powershell
# Creates an Azure Container Registry
az acr create --resource-group $resourceGroup --name $acrName --location $location --admin-enabled true --sku Standard
```

```powershell
# Get the details of an Azure Container Registry
$dockerServer = az acr show --name $acrName --query loginServer
```

```powershell
# Manage login credentials for Azure Container Registries
$dockerSecret = az acr credential show --name $acrName --query passwords[0].value
```

```powershell
# Create a Secret by providing credentials
kubectl create secret docker-registry $regcred --docker-server=$dockerServer --docker-username=$acrName --docker-password=$dockerSecret --docker-email=$dockerEmail
```

```powershell
# Inspecting the Secret regcred
kubectl get secret $regcred --output=yaml
```

```powershell
# Queues a quick build, providing streaming logs for an Azure Container Registry
az acr build --registry $acrName --image "$(repo/image:tag)" --file $dockerfile --platform $nodeOs .
$image = "$dockerServer/$(repo/image:tag)"
```

## kubectl

```powershell
# $ENV:KUBECONFIG = $(~/.kube/config)
```

```powershell
# create resource(s)
kubectl apply -f $deployment.yaml 
```

```powershell
# Print IPs of the Service
$externalIP = kubectl get svc $loadbalancer -o jsonpath='{.status.loadBalancer.ingress[].ip}' 
```

```powershell
# List all services in the namespace
kubectl get services 
```
