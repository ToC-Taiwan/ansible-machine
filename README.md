# ANSIBLE MACHINE

[![Actions](https://img.shields.io/github/actions/workflow/status/ToC-Taiwan/ansible-machine/actions.yml?style=for-the-badge&logo=github)](https://github.com/ToC-Taiwan/ansible-machine/actions/workflows/actions.yml)
[![Ansible](https://img.shields.io/badge/Ansible-2.14.3-red?logo=ansible&logoColor=red&style=for-the-badge)](https://www.ansible.com)
[![Python](https://img.shields.io/badge/Python-3.10-yellow?logo=python&logoColor=yellow&style=for-the-badge)](https://python.org)

## Target

- ### [Machine Setup](./docs/machine-setup.md)

- ### [Let's Encrypt](./docs/self-hosted-cert.md)

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

## Reset python environment

```sh
pip3 freeze > requirements.txt
pip3 uninstall -y -r requirements.txt
rm -rf requirements.txt
```
