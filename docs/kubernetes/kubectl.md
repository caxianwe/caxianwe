# Connect to K8S Cluster

## Tools

Install necessary packages if they are missing (Run the following commands with administrative permission.).

- Install choco

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
```

- Install kubectl

```powershell
choco install kubernetes-cli
```

- Install helm

```powershell
choco install kubernetes-helm
helm init --upgrade # keep version consistent between client and server
```

## Connect to pod

1. [Download k8s configuration file](https://ceapex.visualstudio.com/Engineering/_git/Docs.Build.Infrastructure?path=%2Fdocs%2Fprepare.md&version=GBdevelop&_a=preview).
2. Set the environment variable 'KUBECONFIG'. Note that you need replace {region} with the region k8s is deployed. e.g. westus.
```powershell
$ENV:KUBECONFIG=(Get-Item "{k8s-cluster-config-path}\arm-template\kubeconfig\kubeconfig.{region}.json").FullName
```
3. Now you can try some commands with kubectl. Here is an example to list all the nodes:
```powerhsell
kubectl get nodes
kubectl get pods
kubectl exec -it <pod> -- powershell
```

```powerhsell
kubectl exec --stdin --tty <pod> -- powershell
kubectl logs <pod>
```

[!Note] If you see such connection error during running kubectl get nodes, please double check whether the environment variable KUBECONFIG is correctly set: Unable to connect to the server: dial tcp [::1]:8080: connectex: No connection could be made because the target machine actively refused it.

## Copy file to pod

```powershell
kubectl cp test.ps1 <pod>:/test.ps1

C:./
C:/test.ps1
```
