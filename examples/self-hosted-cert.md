# Let's Encrypt

- new cert: make sure `$server_ip` is exposed to internet
- curl is required

```sh
apt update
apt install -y curl
```

- set variables

```sh
macvlan_name="tocvlan"
macvlan_parent="ens224"
macvlan_subnet="172.20.10.0/24"
macvlan_gateway="172.20.10.1"

cert_path="/root/certbot_data"
server_ip="172.20.10.225"
cert_bot_ip="172.20.10.9"
domain_name="trader.tocraw.com"
```

- new cert
  - variables should be set before

```sh
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
