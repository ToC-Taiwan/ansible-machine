# ANSIBLE MACHINE

[![Actions](https://github.com/ToC-Taiwan/ansible-machine/actions/workflows/actions.yml/badge.svg)](https://github.com/ToC-Taiwan/ansible-machine/actions/workflows/actions.yml)
[![Ansible](https://img.shields.io/badge/Ansible-2.14.2-red?logo=ansible&logoColor=red)](https://www.ansible.com)
[![Python](https://img.shields.io/badge/Python-3.10.9-yellow?logo=python&logoColor=yellow)](https://python.org)

## Install Ansible

- Debian

```sh
python3 -m pip install ansible ansible-lint
```

```sh
# check pip version
python3 -m pip -V

# If No module named pip, install it
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
rm get-pip.py

# If No module named 'distutils.cmd', install `python3-distutils`, then run again
apt install -y python3-distutils
```

## Check hosts

- list

```sh
ansible-inventory -i inventory --list
```

- ping

```sh
ansible all -m ping -i inventory
```

- Get IP

```ansible
- name: Setting host IP and Port
  ansible.builtin.set_fact:
    remote_ip: "{{ hostvars[inventory_hostname]['ansible_env'].SSH_CONNECTION.split(' ')[2] }}"
    remote_port: "{{ hostvars[inventory_hostname]['ansible_env'].SSH_CONNECTION.split(' ')[3] }}"

- name: Show IP and Port
  ansible.builtin.debug:
    msg: "IP: {{ remote_ip }}, Port: {{ remote_port }}"
```

## iventory

```yml
all:
    children:
        toc:
            hosts:
                trader:
                    ansible_host: 172.20.10.96
                    ansible_port: 22
                center:
                    ansible_host: 172.20.10.99
                    ansible_port: 22
    vars:
        ansible_user: root
```

## Debian initial

- Use root

```sh
su -
```

```sh
echo '#!/bin/bash
apt update
apt upgrade -y
apt autoremove -y' > /root/update.sh && \
chmod +x /root/update.sh
/root/update.sh

echo '#!/bin/bash
usermod -aG sudo timhsu
timhsukey="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEtmV/jvROZGXNUak4JnN0hljHUTDq8bysfTYT0eaJ6 maochindada@gmail.com"
mkdir ~/.ssh
echo $timhsukey > ~/.ssh/authorized_keys
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N "" -C $HOSTNAME
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh-keyscan github.com > ~/.ssh/known_hosts
sed -i "/^#PermitRootLogin/c PermitRootLogin yes" /etc/ssh/sshd_config
cat ~/.ssh/id_ed25519.pub
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/id_ed25519' > ./first_init.sh && \
chmod +x ./first_init.sh && \
./first_init.sh && \
rm -f ./first_init.sh

echo 'allow-hotplug ens224
iface ens224 inet dhcp' >> /etc/network/interfaces

apt install -y git sudo curl
```

## Let's Encrypt

- new cert: make sure `172.20.10.225` is exposed to internet

```sh
cert_path=/root/certbot_data

rm -rf $cert_path
mkdir -p $cert_path/www
mkdir -p $cert_path/conf

docker stop nginx
docker stop certbot
docker system prune --volumes -f

echo 'server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name trader.tocraw.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
}
' > nginx_default.conf

docker network create -d macvlan \
  --subnet=172.20.10.0/24 \
  --gateway=172.20.10.1 \
  -o parent=ens224 \
  tocvlan

docker run -d \
    --network tocvlan \
    --ip=172.20.10.225 \
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
    -d trader.tocraw.com

curl https://ssl-config.mozilla.org/ffdhe2048.txt > $cert_path/conf/live/trader.tocraw.com/dhparam
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
