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
python3 -m pip install ansible
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
