# ANSIBLE MACHINE

## Install Ansible

```sh
python3 -m pip -V
```

- If No module named pip, install it

```sh
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
rm get-pip.py
```

- If No module named 'distutils.cmd', install `python3-distutils`, then run again

```sh
apt install -y python3-distutils
```

```sh
python3 -m pip install ansible ansible-lint
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
