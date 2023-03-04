# Let's Encrypt

- new cert: make sure `$server_ip` is exposed to internet

```sh
cert_path="/root/certbot_data"
domain_name="blog.tocandraw.com"
server_ip="172.20.10.242"

rm -rf $cert_path
mkdir -p $cert_path/www
mkdir -p $cert_path/conf

docker stop nginx
docker stop certbot
docker system prune --volumes -f

conf="server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name ${domain_name};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}
"
echo $conf > nginx_default.conf

docker network create -d macvlan \
  --subnet=172.20.10.0/24 \
  --gateway=172.20.10.1 \
  -o parent=ens224 \
  tocvlan

docker run -d \
    --network tocvlan \
    --ip=$server_ip \
    --restart always \
    --name nginx \
    -v $(pwd)/nginx_default.conf:/etc/nginx/conf.d/nginx_default.conf:ro\
    -v $cert_path/www:/var/www/certbot/:ro \
    -v $cert_path/conf:/etc/nginx/ssl/:ro \
    nginx:latest

docker stop certbot
docker system prune --volumes -f
docker run -it \
    --name certbot \
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

curl https://ssl-config.mozilla.org/ffdhe2048.txt > $cert_path/conf/live/$domain_name/dhparam

docker stop nginx
docker stop certbot
docker system prune --volumes -f
rm nginx_default.conf
```

- renew cert

```sh
cert_path=/root/certbot_data

docker stop certbot
docker system prune --volumes -f
docker run -it \
    --name certbot \
    -v $cert_path/www:/var/www/certbot/:rw \
    -v $cert_path/conf:/etc/letsencrypt/:rw \
    certbot/certbot:latest renew

docker stop certbot
docker system prune --volumes -f
```
