# config.yml

- Hostnames

YAML file with the word "node" plus the last octet of the node's ip address and the specified hostname.

Example:

node44: myhost

- auth_keys

SSH public key file to be added to the host

# Sample

default_password: "123456"

auth_keys:
    - "abc"
    - "xyz"

hosts:
    node1:
        name: node-one
        enable-eth1: true
