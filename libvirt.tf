# instance the provider
provider "libvirt" {
  uri = "qemu+ssh://root@127.0.0.1/system"
}

resource "random_string" "rand" {
  length  = 6
  special = false
  upper   = false
}


# We fetch the latest debian release image from their mirrors
resource "libvirt_volume" "image-qcow2" {
  name   = "vol-${var.projectname == "" ? "{random_string.rand.result}" : "{var.projectname}" }"
  pool   = "default"
  source =  var.image_path
  format = "qcow2"
}

resource "libvirt_volume" "disk_resized" {
  name           = "${var.projectname}-vol-${count.index}"
  base_volume_id = libvirt_volume.image-qcow2.id
  pool           = "default"
  size           = format("%d", var.disk_size*1024*1024*1024)
  count          = var.instances
}

data "template_file" "user_data" {
  template = templatefile("${path.module}/cloud_init.tpl", { 
    ssh_key = "${var.ssh_key}"
    root_password = "${var.root_password}"
    user = "${var.user}"
    hostname = "${var.hostname}-${count.index}"
    })

  count = var.instances
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

resource "libvirt_network" "eth0" {
  name      = "${var.projectname}-net"
  mode      = "nat"
  addresses = var.cidr
  dhcp {
    enabled = true
  }
  dns {
    enabled = true
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit-${count.index}-${random_string.rand.result}"
  user_data      = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
  count = var.instances
}

# Create the machine
resource "libvirt_domain" "domain" {
  name = "${var.hostname}-${count.index}"
  memory = "1024"
  vcpu   = 1
  count  = var.instances

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  network_interface {
    network_id = libvirt_network.eth0.id
    mac = "${var.mac_prefix}:a${count.index + 1}"
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = element(libvirt_volume.disk_resized.*.id, count.index)
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "ipv4" {
  value = libvirt_domain.domain.*.network_interface.0.addresses
}

terraform {
  required_version = ">= 0.12"
}
