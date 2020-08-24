This resources used to create my home lab

You have to build [terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt) and initialize terraform

- download terraform and initialize `terraform init`

- create variables inside terraform.tfvars

```
instances = 3
image_path = "/srv/debian-10-generic-amd64-daily-20200515-264.qcow2"
user = "cladmin"
ssh_key = "ssh-ed25519 ****"
ssh_private_key_location = "~/.ssh/id_ed25519"
hostname = "labvm"
root_password = "terraform-linux"
```

and you are ready to go

- `make plan`

- `make apply`

TODO:
* change hostname
* 