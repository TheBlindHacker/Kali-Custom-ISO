# Kali-Unattended-install
Install Kali with out user input 

To make an unattended install with Kali-Linux (meaning no user input other than selecting install) you need to install the latest version of Kali (https://www.kali.org/downloads/) you can use a Kali VM(https://www.offensive-security.com/kali-linux-vm-vmware-virtualbox-hyperv-image-download/) 

After install or unpacking the following steps are the same across the board.

#Install live-build 
apt-get install live-build

#Git clone the live-build configs
git clone git://git.kali.org/live-build-config.git
cd live-build-config

#Create a binary hook which adds a new boot menu option for Unattended Install
wget https://www.kali.org/dojo/blackhat-2015/unattended.txt -O ./kali-config/common/hooks/02-unattended-boot.binary
chmod +x kali-config/common/hooks/02-unattended-boot.binary

##what it should look like
cat /kali-config/common/hooks/02-unattended-boot.binary

#!/bin/sh

cat >>binary/isolinux/install.cfg <<END
label install
	menu label ^Unattended Install
	menu default
	linux /install/vmlinuz
	initrd /install/initrd.gz
	append vga=788 -- quiet file=/cdrom/install/preseed.cfg locale=en_US keymap=us hostname=kali domain=local.lan
END

#Set up an unattended preseed file
wget https://www.kali.org/dojo/preseed.cfg -O ./kali-config/common/includes.installer/preseed.cfg

##what it should look like
cat ./kali-config/common/includes.installer/preseed.cfg

## Added
d-i debian-installer/language string en
d-i debian-installer/country string US
d-i debian-installer/locale string en_US.UTF-8
d-i keymap select us
d-i netcfg/choose_interface select auto


#d-i debian-installer/locale string en_US
#d-i console-keymaps-at/keymap select us

## Added
apt-mirror-setup apt-setup/use_mirror boolean true

d-i mirror/country string enter information manually
d-i mirror/suite string kali-rolling
d-i mirror/codename string kali-rolling
d-i mirror/http/hostname string http.kali.org
d-i mirror/http/directory string /kali
d-i mirror/http/proxy string
d-i clock-setup/utc boolean true
d-i time/zone string US/Eastern

# Disable volatile and security
d-i apt-setup/services-select multiselect

# Enable contrib and non-free
d-i apt-setup/non-free boolean true
d-i apt-setup/contrib boolean true

d-i partman-auto/method string regular
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-lvm/confirm boolean true
d-i partman-auto/choose_recipe select atomic
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Add our own security mirror
#d-i apt-setup/local0/repository string http://archive.kali.org/kali-security kali/updates main
#d-i apt-setup/local0/comment string Security updates
#d-i apt-setup/local0/source boolean false
#d-i apt-setup/use_mirror boolean true

# Upgrade installed packages
tasksel tasksel/first multiselect standard
d-i pkgsel/upgrade select full-upgrade
# Install a limited subset of tools from the Kali Linux repositories
d-i pkgsel/include string openssh-server openvas metasploit-framework metasploit nano

# Change default hostname

## Changed
d-i netcfg/get_hostname string remote
d-i netcfg/get_domain string remote.lan

d-i netcfg/hostname string kali

# Do not create a normal user account
d-i passwd/make-user boolean false
d-i passwd/root-password password toor
d-i passwd/root-password-again password toor

popularity-contest popularity-contest/participate boolean false
d-i grub-installer/only_debian boolean true
## Changed false to true
d-i grub-installer/with_other_os boolean true
d-i finish-install/reboot_in_progress note

## Added # Remove the line below to select where Grub is installed during
## install
d-i grub-installer/bootdev  string /dev/sda

#d-i preseed/late_command string \
#    in-target wget http://192.168.101.54/postseed.sh; \
#    in-target /bin/bash -x chmod 755 ./postseed.sh; \
#    in-target /bin/bash -x ./postseed.sh;

#BUILD THE ISO
./build.sh --verbose
