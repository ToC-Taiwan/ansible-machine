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
ansible-inventory -i ./inventories/production/hosts.yml --list
```

- ping

```sh
ansible virtualmachines -m ping -i ./inventories/production/hosts.yml
```

## Run

```sh
ansible-playbook -i ./inventories/production/hosts.yml site.yml
```
