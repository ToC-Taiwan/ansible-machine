# BLOG SETUP

```css
.wp-block-kevinbatdorf-code-block-pro{
 margin-bottom: 30px;
}
```

```css
.wp-block-latest-posts__post-title {
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
}

h2.wp-block-heading {
    padding-bottom: 15px;
}
```

## Run on macOS standalone

```sh
docker stop nginx
docker stop wordpress
docker stop mariadb
docker system prune --volumes -f

net_name=tocvlan
docker network create $net_name
docker run --rm --name mariadb -d \
    -p 3306:3306 \
    --network=$net_name \
    -e MARIADB_ROOT_PASSWORD=asdf0000 \
    -e MARIADB_ROOT_HOST="%" \
    mariadb:latest
```

```sh
echo "DROP DATABASE IF EXISTS wordpress;
CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;" > setup.sql
db_host=127.0.0.1
mysql -u root -pasdf0000 -h $db_host < setup.sql
rm setup.sql
```

```sh
docker volume create wordpress_data
docker run --rm -d \
    --network=$net_name \
    --name=wordpress \
    -e WORDPRESS_DB_HOST=mariadb \
    -e WORDPRESS_DB_USER=root \
    -e WORDPRESS_DB_PASSWORD=asdf0000 \
    -e WORDPRESS_DB_NAME=wordpress \
    -e WORDPRESS_TABLE_PREFIX=wp_ \
    -v wordpress_data:/var/www/html \
    wordpress:fpm
```

```sh
echo "access_log off;
server {
    listen 80;
    listen [::]:80;
    server_name 127.0.0.1;

    index index.php index.html index.htm;
    root /var/www/html;

    server_tokens off;
    client_max_body_size 75M;

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    location ~ \.php$ {
        try_files \$uri = 404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }

    location ~ /\.ht {
        deny all;
    }
}" > nginx.conf

docker run --rm -d \
    --name nginx \
    -p 80:80 \
    --network=$net_name \
    --volumes-from wordpress \
    -v $(pwd)/nginx.conf:/etc/nginx/conf.d/nginx.conf:ro \
    nginx:stable
```
