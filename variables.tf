variable "ssh_key" {
  type = string
}

variable "ssh_private_key_location" {
  type = string
}

variable "instances" {
  type = number
}

variable "image_path" {
  type = string
}

variable "hostname" {
  type = string
}

variable "root_password" {
  type = string
}

variable "user" {
  type = string
}

variable "projectname" {
  type = string
}

variable "disk_size" {
  type = number
}

variable "cidr" {
  type    = list
}

variable "mac_prefix" {
  type = string
}
