# Setup shadowsocks

## Run Shadowsocks in Azure Container Instance (ACI)

```bash
# az login
az account list
az account set --subscription "Pay As You Go"
az account show
# az group delete --name ShadowsocksRG
# az group create --location eastus --name ShadowsocksRG
az container create --resource-group ShadowsocksRG --name shadowsocks-libev --image shadowsocks/shadowsocks-libev --cpu 1 --memory 1 --ip-address public --ports 8388 --environment-variables METHOD=chacha20-ietf-poly1305 PASSWORD=<--your password--> --restart-policy Always
az container show --name shadowsocks-libev --resource-group ShadowsocksRG --query "ipAddress.ip"
az container logs --name shadowsocks-libev --resource-group ShadowsocksRG
```

## Run Shadowsocks in Azure Kubernetes Service (AKS)

- Create Kubernetes cluster choosing a suitable [vm size](vm-size-eastus.json), here is the [pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator).

```bash
# az login
az account list
az account set --subscription "Pay As You Go"
az account show
# az group delete --name KubernetesCluster-RG
# az group create --location eastus --name KubernetesCluster-RG
# az vm list-sizes --location "eastus"
az aks create --resource-group KubernetesCluster-RG --name KubernetesCuster --node-vm-size Standard_B1ls --generate-ssh-keys
az aks get-credentials --resource-group KubernetesCluster-RG --name KubernetesCuster --admin
```

- Create the Deployment: [ss-k8s-apply.sh](ss-docker-apply/ss-k8s-apply.sh)

- Find IP from [loadbalancer](ss-docker-apply/ss-k8s.yml#L45)

```bash
kubectl get svc shadowsocks-lb -o jsonpath='{.status.loadBalancer.ingress[].ip}'
```

## Run Shadowsocks in Docker

```bash
# docker pull shadowsocks/shadowsocks-libev
# docker run -e PASSWORD=<--your password--> -e METHOD=aes-256-gcm -p 8388:8388 -p 8388:8388/udp -d --restart always shadowsocks/shadowsocks-libev 
```

[ss-docker-apply.sh](ss-docker-apply/ss-docker-apply.sh)

## Setup Fail2ban Shadowsocks

### Setup VM

```bash
az account set --subscription "Pay As You Go"
# az group delete --name ShadowsocksRG
az group create --location eastus --name ShadowsocksRG
az vm create --resource-group ShadowsocksRG --name shadowsocks-libev --image UbuntuLTS --size Standard_B1ls --authentication-type all --admin-username "<--your username-->" --admin-password "<--your password-->" --generate-ssh-keys
az network nsg rule create --resource-group ShadowsocksRG --nsg-name shadowsocks-libevNSG --name Port_8388 --protocol * --priority 1010 --destination-port-range 8388
```

### Connect to VM

```bash
ssh -i <--private key path--> <--username-->@<--publicIpAddress-->
```

### Setup Shadowsocks

```bash
sudo apt-get update
sudo apt install shadowsocks-libev

sudo nano /etc/shadowsocks-libev/config.json
{
  "server": [ "::0", "0.0.0.0" ],
  "mode": "tcp_and_udp",
  "server_port": 8388,
  "local_port": 1080,
  "password": "<--your password-->",
  "timeout": 60,
  "method": "aes-256-gcm"
}

sudo systemctl restart shadowsocks-libev.service
# journalctl -u shadowsocks-libev.service/shadowsocks-libev/config.json
sudo systemctl status shadowsocks-libev.service

sudo systemctl enable shadowsocks-libev.service
```

### Setup Fail2ban

#### Install fail2ban

```bash
sudo apt install fail2ban
```

#### Create a filter

```bash
sudo nano /etc/fail2ban/filter.d/shadowsocks-libev.conf
```

```conf
[INCLUDES]
before = common.conf

[Definition]
_daemon = ss-server

failregex = ^\w+\s+\d+ \d+:\d+:\d+\s+%(__prefix_line)sERROR:\s+failed to handshake with <HOST>: authentication error$

ignoreregex =

datepattern = %%Y-%%m-%%d %%H:%%M:%%S
```

### Update jail config

```bash
sudo nano /etc/fail2ban/jail.local
```

```conf
[shadowsocks-libev]
enabled = true
filter = shadowsocks-libev
port = 0:65535
logpath = /var/log/syslog

maxretry = 1
findtime = 3600
bantime = -1
```

### Start fail2ban

```bash
sudo systemctl restart fail2ban
sudo systemctl status fail2ban
sudo fail2ban-client status shadowsocks-libev

sudo systemctl enable fail2ban
```

## Password generator

```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using Microsoft.AspNetCore.Identity;

private static KeyValuePair<string, string> GenerateRandomPassword(PasswordOptions opts = null)
{
    opts ??= new PasswordOptions()
    {
        RequiredLength = 8,
        RequiredUniqueChars = 4,
        RequireDigit = true,
        RequireLowercase = true,
        RequireNonAlphanumeric = true,
        RequireUppercase = true
    };

    var randomChars = new string[]
    {
        "ABCDEFGHJKLMNOPQRSTUVWXYZ",
        "abcdefghijkmnopqrstuvwxyz",
        "0123456789",
        "!@$?_-"
    };

    var rand = new Random(Environment.TickCount);
    var chars = new List<char>();

    if (opts.RequireUppercase)
        chars.Insert(rand.Next(0, chars.Count),
            randomChars[0][rand.Next(0, randomChars[0].Length)]);

    if (opts.RequireLowercase)
        chars.Insert(rand.Next(0, chars.Count),
            randomChars[1][rand.Next(0, randomChars[1].Length)]);

    if (opts.RequireDigit)
        chars.Insert(rand.Next(0, chars.Count),
            randomChars[2][rand.Next(0, randomChars[2].Length)]);

    if (opts.RequireNonAlphanumeric)
        chars.Insert(rand.Next(0, chars.Count),
            randomChars[3][rand.Next(0, randomChars[3].Length)]);

    for (int i = chars.Count; i < opts.RequiredLength
        || chars.Distinct().Count() < opts.RequiredUniqueChars; i++)
    {
        string rcs = randomChars[rand.Next(0, randomChars.Length)];
        chars.Insert(rand.Next(0, chars.Count),
            rcs[rand.Next(0, rcs.Length)]);
    }

    var password = new string(chars.ToArray());
    return new KeyValuePair<string, string>(password, HashPassword(password));
}

private static string HashPassword(string password)
{
    var salt = new byte[128 / 8];
    using (var rngCsp = new RNGCryptoServiceProvider())
    {
        rngCsp.GetNonZeroBytes(salt);
    }

    var hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
        password: password,
        salt: salt,
        prf: KeyDerivationPrf.HMACSHA256,
        iterationCount: 100000,
        numBytesRequested: 256 / 8));

    return hashed;
}
```
