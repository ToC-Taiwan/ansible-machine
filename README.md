# ANSIBLE MACHINE

## Install Ansible

```sh
python3 -m pip -V
```

- If No module named pip, install it

```sh
apt install -y python3-distutils
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
rm get-pip.py
```

```sh
python3 -m pip install ansible
```

## Building an inventory

```sh
ansible-inventory -i ./inventories/production/hosts.yml --list
ansible virtualmachines -m ping -i ./inventories/production/hosts.yml
```
