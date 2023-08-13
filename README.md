# ANSIBLE MACHINE

[![Actions](https://img.shields.io/github/actions/workflow/status/ToC-Taiwan/ansible-machine/actions.yml?style=for-the-badge&logo=github)](https://github.com/ToC-Taiwan/ansible-machine/actions/workflows/actions.yml)
[![Ansible](https://img.shields.io/badge/Ansible-2.14.3-red?logo=ansible&logoColor=red&style=for-the-badge)](https://www.ansible.com)
[![Python](https://img.shields.io/badge/Python-3.10-yellow?logo=python&logoColor=yellow&style=for-the-badge)](https://python.org)

## Target

- Debian

```sh
# Ii will encounter `module named 'distutils.cmd'`, install `python3-distutils`
apt install -y python3-distutils

# No module named pip, so install it
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
rm get-pip.py

# check pip version
python3 -m pip -V
```

```sh
python3 -m pip install ansible ansible-lint jmespath
```

## Deploy

- install basci packages

```sh
./scripts/install_basic.sh
```

### Check hosts

- list

```sh
ansible-inventory -i inventory --list
```

- ping

```sh
ansible all -m ping -i inventory
```

- Get IP

```yaml
- name: Setting host IP and Port
  ansible.builtin.set_fact:
    remote_ip: "{{ hostvars[inventory_hostname]['ansible_env'].SSH_CONNECTION.split(' ')[2] }}"
    remote_port: "{{ hostvars[inventory_hostname]['ansible_env'].SSH_CONNECTION.split(' ')[3] }}"

- name: Show IP and Port
  ansible.builtin.debug:
    msg: "IP: {{ remote_ip }}, Port: {{ remote_port }}"
```

## inventory

```yml
all:
    children:
        toc:
            hosts:
                trader:
                    ansible_host: xxx.xxx.xxx.xxx
                    ansible_port: 22
                center:
                    ansible_host: xxx.xxx.xxx.xxx
                    ansible_port: 22
    vars:
        ansible_user: root
```

## Debian machine initial

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

# replace p_key with your public key
p_key="ssh-ed25519 blahblahblah"

echo '#!/bin/bash
mkdir ~/.ssh
echo '${p_key}' > ~/.ssh/authorized_keys
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
```

```sh
host_ip="10.0.0.98"
# if interface name is not ens224, replace it
echo '# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug ens192
iface ens192 inet static
 address '${host_ip}'
 netmask 255.255.255.0
 gateway 10.0.0.1
 dns-nameservers 10.0.0.1

allow-hotplug ens224
iface ens224 inet dhcp

# This is an autoconfigured IPv6 interface
iface ens192 inet6 auto
' > /etc/network/interfaces
```

## Reset python environment

```sh
pip3 freeze > requirements.txt
pip3 uninstall -y -r requirements.txt
rm -rf requirements.txt
```

## Example

- ### [Let's Encrypt](./examples/self-hosted-cert.md)
