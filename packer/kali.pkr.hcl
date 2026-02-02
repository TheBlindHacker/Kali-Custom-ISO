packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.kali.org/kali-2025.4/kali-linux-2025.4-installer-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:3b4a3a9f5fb6532635800d3eda94414fb69a44165af6db6fa39c0bdae750c266"
}

variable "vm_name" {
  type    = string
  default = "kali-linux-custom"
}

source "virtualbox-iso" "kali" {
  guest_os_type        = "Debian_64"
  iso_url              = var.iso_url
  iso_checksum         = var.iso_checksum
  ssh_username         = "root"
  ssh_password         = "toor"
  ssh_wait_timeout     = "20m"
  shutdown_command     = "echo 'packer' | shutdown -P now"
  disk_size            = 40000
  cpus                 = 2
  memory               = 4096
  http_directory       = "http"
  
  boot_wait = "5s"
  boot_command = [
    "<esc><wait>",
    "install auto=true priority=critical preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"
  ]

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--vram", "32"]
  ]
}

build {
  sources = ["source.virtualbox-iso.kali"]

  provisioner "shell" {
    inline = [
      "echo 'Upgrading packages...'",
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get upgrade -y",
      "echo 'Installing additional tools...'",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y virtualbox-guest-x11"
    ]
  }
}
