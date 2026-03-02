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
  default = "https://cdimage.kali.org/kali-2026.1/kali-linux-2026.1-installer-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  # Checksum for Kali 2026.1 Installer AMD64.
  # By using the official SHA256SUMS URL, Packer will automatically fetch and verify
  # the checksum for the ISO filename specified in iso_url.
  default = "https://cdimage.kali.org/kali-2026.1/SHA256SUMS"
}

variable "vm_name" {
  type    = string
  default = "kali-linux-custom-2026.1"
}

source "virtualbox-iso" "kali" {
  guest_os_type        = "Debian_64"
  iso_url              = var.iso_url
  iso_checksum         = var.iso_checksum
  ssh_username         = "root"
  ssh_password         = "toor"
  ssh_wait_timeout     = "20m"
  
  # Shutdown command
  shutdown_command     = "echo 'packer' | shutdown -P now"
  
  disk_size            = 60000 
  cpus                 = 2
  memory               = 4096
  
  # Headless mode by default? 
  # headless = true
  
  http_directory       = "http"
  
  boot_wait = "5s"
  boot_command = [
    "<esc><wait>",
    "install auto=true priority=critical preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"
  ]

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--vram", "128"],
    ["modifyvm", "{{.Name}}", "--audio", "none"],
    ["modifyvm", "{{.Name}}", "--clipboard", "bidirectional"],
    ["modifyvm", "{{.Name}}", "--draganddrop", "bidirectional"]
  ]
  
  # Export settings
  format = "ova"
}

build {
  sources = ["source.virtualbox-iso.kali"]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    inline = [
      "echo 'Waiting for apt lock...'",
      "while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do sleep 1; done",
      "echo 'Upgrading packages...'",
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get dist-upgrade -y",
      "apt-get autoremove -y",
      "apt-get clean",
      "echo 'Installing Guest Additions dependencies...'",
      "apt-get install -y virtualbox-guest-x11"
    ]
  }
}
