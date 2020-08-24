#cloud-config
# vim: syntax=yaml
#
# ***********************
# 	---- for more examples look at: ------
# ---> https://cloudinit.readthedocs.io/en/latest/topics/examples.html
# ******************************
#
# This is the configuration syntax that the write_files module
# will know how to understand. encoding can be given b64 or gzip or (gz+b64).
# The content will be decoded accordingly and then written to the path that is
# provided.
#
# Note: Content strings here are truncated for example purposes.
ssh_pwauth: yes
chpasswd:
  list: |
     root:${root_password}
  expire: False

preserve_hostname: True
fqdn: ${hostname}.local
hostname: ${hostname}

users:
  - name: ${user}
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${ssh_key}

growpart:
  mode: auto
  devices: ['/']

# disable cloudinit after first boot
#write_files:
#- content: 1
#  owner: root:root
#  path: /etc/cloud/cloud-init.disabled
  