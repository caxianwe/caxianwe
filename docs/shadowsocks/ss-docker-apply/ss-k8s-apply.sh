export password=<--your password-->
export method=chacha20-ietf-poly1305
export port=8388
cat ss-k8s.yml | envsubst | kubectl apply -f -

export host=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}')
export port=$(kubectl get svc shadowsocks-svc -o jsonpath='{$.spec.ports[*].nodePort}')
echo $host:$port
