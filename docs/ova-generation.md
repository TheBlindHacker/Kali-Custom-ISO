# Generating Kali Linux 2026.1 OVA with Packer

This document outlines the process of building a custom Kali Linux Virtual Machine (VM) and exporting it as an OVA file using HashiCorp Packer.

## Prerequisites

Before you begin, ensure you have the following installed on your host machine:

1.  **[Packer](https://developer.hashicorp.com/packer/install)** (v1.7.0 or later)
2.  **[VirtualBox](https://www.virtualbox.org/)** (v6.1 or later)
3.  **Git**

## Setup

1.  **Clone the Repository**:
    ```bash
    git clone <repository-url>
    cd <repository-directory>/packer
    ```

2.  **Initialize Packer Plugins**:
    Packer needs to install the VirtualBox plugin.
    ```bash
    packer init .
    ```

## Configuration

The build is configured via the `kali.pkr.hcl` file. Key variables you might need to adjust:

### ISO Selection
The default configuration targets **Kali Linux 2026.1**.

*   **URL**: `iso_url` defaults to the 2026.1 installer. If this release is not yet available, or if you want to use a weekly build, update this variable in `kali.pkr.hcl` or override it via command line.
*   **Checksum**: **CRITICAL**. You **must** update the `iso_checksum` variable to match the SHA256 checksum of the ISO file you are using. The default value is a placeholder and the build will fail if not updated.

### Preseed Configuration
The installation is automated using a preseed file located at `http/preseed.cfg`.
*   **User**: `root` / `toor`
*   **Packages**: Installs `kali-linux-default`, `gvm` (OpenVAS), `metasploit-framework`, etc.
*   **Firmware**: Includes `non-free-firmware` support.

## Building the OVA

1.  **Validate the Template**:
    Ensure there are no syntax errors.
    ```bash
    packer validate .
    ```

2.  **Run the Build**:
    Start the build process. This will download the ISO (if not cached), boot a VM in VirtualBox, and run the installer.
    ```bash
    packer build kali.pkr.hcl
    ```
    *   **Note**: This process can take 15-30 minutes depending on your internet connection and hardware.
    *   **Headless Build**: The default config might show the GUI. To run headlessly (no GUI window), add `-var 'headless=true'` if the variable is supported or uncomment `headless = true` in the HCL file.

3.  **Output**:
    Upon successful completion, you will find a `.ova` file in the `output-virtualbox-iso` directory (or wherever `output_directory` is configured).

## Troubleshooting

*   **Checksum Mismatch**: If you see a checksum error, verify the `iso_checksum` in `kali.pkr.hcl` matches your downloaded ISO.
*   **Stuck at Boot**: If the VM hangs at the boot menu, ensure the `boot_command` key sequences match the bootloader of the ISO you are using.
*   **Network Timeouts**: If `apt-get` fails, check your internet connection or try a different mirror in `http/preseed.cfg`.
