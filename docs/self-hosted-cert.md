# Let's Encrypt

- new cert: make sure `$server_ip` is exposed to internet
- curl is required

```sh
apt update
apt install -y curl
```

- set variables

```sh
cert_path="/root/certbot_data"
cert_bot_ip="10.0.0.9"

server_ip=""
domain_name=""
if [ $HOSTNAME = "trader" ]; then
    server_ip="10.0.0.20"
    domain_name="trader.tocraw.com"
elif [ $HOSTNAME = "blog" ]; then
    server_ip="10.0.0.10"
    domain_name="blog.tocandraw.com"
fi

# if host_ip is empty, exit
if [ -z $server_ip ]; then
    # print error message
    echo "server_ip is empty"
    exit 1
fi

echo "HOSTNAME: $HOSTNAME"
echo "IP: $server_ip"
echo "DOMAIN: $domain_name"

macvlan_name="tocvlan"
macvlan_parent="ens224"
macvlan_subnet="10.0.0.0/24"
macvlan_gateway="10.0.0.1"

rm -rf $cert_path

mkdir -p $cert_path/www
mkdir -p $cert_path/conf

docker stop nginx
docker stop certbot
docker system prune --volumes -f
docker network create -d macvlan \
    --subnet=$macvlan_subnet \
    --gateway=$macvlan_gateway \
    -o parent=$macvlan_parent \
    $macvlan_name

echo "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name ${domain_name};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}" >nginx_default.conf

docker run -d \
    --name nginx \
    --network $macvlan_name \
    --ip=$server_ip \
    -v $(pwd)/nginx_default.conf:/etc/nginx/conf.d/nginx_default.conf:ro \
    -v $cert_path/www:/var/www/certbot/:ro \
    -v $cert_path/conf:/etc/nginx/ssl/:ro \
    nginx:latest

docker run -it \
    --name certbot \
    --network $macvlan_name \
    --ip=$cert_bot_ip \
    -v $cert_path/www:/var/www/certbot/:rw \
    -v $cert_path/conf:/etc/letsencrypt/:rw \
    certbot/certbot:latest certonly \
    -v \
    -n \
    --agree-tos \
    --webroot \
    --webroot-path /var/www/certbot/ \
    -m maochindada@gmail.com \
    -d $domain_name

rm nginx_default.conf
curl https://ssl-config.mozilla.org/ffdhe2048.txt >$cert_path/conf/live/$domain_name/dhparam

docker stop nginx
docker stop certbot
docker system prune --volumes -f
```

- renew cert
  - variables are the same as new cert

```sh
docker stop certbot
docker system prune --volumes -f
docker run -it \
    --name certbot \
    --network $macvlan_name \
    --ip=$cert_bot_ip \
    -v $cert_path/www:/var/www/certbot/:rw \
    -v $cert_path/conf:/etc/letsencrypt/:rw \
    certbot/certbot:latest renew

docker stop certbot
docker system prune --volumes -f
```
