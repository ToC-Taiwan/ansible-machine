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

# if interface name is not ens224, replace it
echo 'allow-hotplug ens224
iface ens224 inet dhcp' >> /etc/network/interfaces
```

## Reset python environment

```sh
pip3 freeze > requirements.txt
pip3 uninstall -y -r requirements.txt
rm -rf requirements.txt
```

## Example

- ### [Let's Encrypt](./examples/self-hosted-cert.md)
