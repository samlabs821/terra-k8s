resource "null_resource" "copy-scripts" {
  connection {
    user     = var.user
    private_key = file(pathexpand(var.ssh_private_key_location))
    host     = libvirt_domain.domain[count.index].network_interface[0].addresses[0]
  }

  count = var.instances

  provisioner "file" {
    source      = "cloud_init.tpl"
    destination = "/tmp/reboot.sh"
  }
}
