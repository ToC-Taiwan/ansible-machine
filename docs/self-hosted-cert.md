# Let's Encrypt

- new cert: make sure `$server_ip` is exposed to internet
- curl is required

```sh
apt update
apt install -y curl
```

```sh
domain_name=""
if [ $HOSTNAME = "trader" ]; then
    domain_name="tocraw.com"
elif [ $HOSTNAME = "blog" ]; then
    domain_name="tocandraw.com"
elif [ $HOSTNAME = "mail" ]; then
    domain_name="mail.tocraw.com"
fi
if [ -z $domain_name ]; then
    echo "domain_name is empty"
    exit 1
fi
echo "HOSTNAME: $HOSTNAME"
echo "DOMAIN: $domain_name"

cert_path="/root/certbot_data"
rm -rf $cert_path
mkdir -p $cert_path/www
mkdir -p $cert_path/conf

docker stop nginx
docker stop certbot
docker system prune --volumes -f

docker network create certer
echo "server {
    listen 80;
    listen [::]:80;
    server_name ${domain_name};

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}" >nginx_default.conf

docker run -d --rm \
    --name nginx \
    --network certer \
    -p 80:80 \
    -v $(pwd)/nginx_default.conf:/etc/nginx/conf.d/nginx_default.conf:ro \
    -v $cert_path/www:/var/www/certbot/:ro \
    -v $cert_path/conf:/etc/nginx/ssl/:ro \
    nginx:stable

docker run -it --rm \
    --name certbot \
    --network certer \
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
docker system prune --volumes -f
```

- renew cert
  - variables are the same as new cert

```sh
cert_path="/root/certbot_data"

docker stop certbot
docker system prune --volumes -f

docker run --rm \
    --name certbot \
    -v $cert_path/www:/var/www/certbot/:rw \
    -v $cert_path/conf:/etc/letsencrypt/:rw \
    certbot/certbot:latest renew

docker stop certbot
docker system prune --volumes -f
```
