export password=<--your password-->
export method=chacha20-ietf-poly1305
export port=8388

docker run -e PASSWORD=${password} -e METHOD=${method} -p${port}:8388 -p${port}:8388/udp -d shadowsocks/shadowsocks-libev

export host=$(curl -s ipinfo.io/json | grep \"ip\"  | awk -F'"' '{ print $4 }')
echo $host:$port