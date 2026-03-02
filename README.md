# Kali Custom ISO / OVA Automation (v2.2)

> **Current Version**: v2.2.0
> **Status**: Stable (Dual-Build Supported, updated for 2026.1)

## Overview
This project provides a robust framework for generating custom Kali Linux environments. Whether you need a physical bootable USB drive ("ISO of Doom") or an automated Virtual Machine for your lab, this repository has a method for you.

We support two distinct build pipelines:

| Feature | Method 1: ISO of Doom | Method 2: VM Automation |
| :--- | :--- | :--- |
| **Output Format** | `.iso` (Hybrid ISO) | `.ova` (Open Virtual Appliance) |
| **Engine** | [Kali Live Build](https://www.kali.org/docs/development/live-build-a-custom-kali-iso/) | [HashiCorp Packer](https://www.packer.io/) |
| **Use Case** | Bootable USB, Physical Hardware, Air-gapped Ops | Virtual Labs, Malware Analysis, CI/CD Pipelines |
| **Base System** | Kali Rolling (Live) | Kali 2026.1 (Installer) |

---

## 📚 Resources & Credits
This project relies on the amazing work of the open-source community.
- **[Kali Linux](https://www.kali.org/)**: The most advanced Penetration Testing Distribution.
- **[Live Build Manual](https://live-team.pages.kali.org/live-build-config/)**: Official documentation for building Kali ISOs.
- **[Packer](https://www.packer.io/)**: Automating image builds for the cloud and data centers.
- **[VirtualBox](https://www.virtualbox.org/)**: Powerful x86 virtualization.

---

## 🛠️ Method 1: The "ISO of Doom II"
*A custom, loaded live system designed for physical deployment.*

### Prerequisites
- Operating System: **Linux** (Debian/Kali preferred) or WSL2.
- User: **Root** privileges are required to build filesystems.

### Quick Start
1.  **Enter the build directory**:
    ```bash
    cd iso-of-doom
    ```

2.  **Run the wrapper script**:
    ```bash
    sudo ./build.sh
    ```
    > ⏳ **Time Estimate**: 30-60 minutes (downloads ~4-5GB of packages).

### Configuration
- **Packages**: Defined in `config/package-lists/doom.list.chroot`. Currently includes the **Kali Top 10** and full desktop environment.
- **Settings**: Defined in `auto/config`.

---

## ☁️ Method 2: VM Automation (Packer)
*A fully automated, unattended installation resulting in a ready-to-use VM, exported as an OVA.*

### Prerequisites
- **[Packer](https://developer.hashicorp.com/packer/install)**
- **[VirtualBox](https://www.virtualbox.org/)**

### Quick Start
1.  **Enter the packer directory**:
    ```bash
    cd packer
    ```

2.  **Initialize Plugins**:
    ```bash
    packer init .
    ```

3.  **Validate Config**:
    ```bash
    packer validate .
    ```

4.  **Build the VM**:
    ```bash
    packer build kali.pkr.hcl
    ```
    > ⏳ **Time Estimate**: 15-30 minutes.

### Details
- Uses the **Kali Linux 2026.1 Installer** ISO.
- Injects a **Preseed** file (`http/preseed.cfg`) to automate the installation.
- Default Credentials: `root` / `toor`.
- **Exports to OVA**: The final artifact is an Open Virtual Appliance (`.ova`) ready for import into VirtualBox or VMware.

> [!TIP]
> **ISO Checksum**: The `iso_checksum` in `kali.pkr.hcl` is configured to automatically fetch and verify the checksum from the official Kali Linux server. If you are using a custom or local ISO, remember to update this variable with the appropriate checksum or local file path.

---

## 📜 Version History

### v2.2.0 - 2026 Refresh
- **Update**: Targeted Kali 2026.1.
- **Feature**: Added OVA export to Packer build.
- **Config**: Updated preseed configuration for modern Kali installers.
- **Docs**: Updated documentation for 2026 workflows.

### v2.1.0 - The Dual-Build Update
- **New Feature**: Added `iso-of-doom` directory for native Live Build support.
- **Documentation**: Completely overhauled README with clear separation of methods and resource links.
- **Improvement**: Standardized project structure.

### v2.0.0 - Packer Modernization
- **Engine Switch**: Implemented Packer for reproducible VM builds.
- **Base Update**: Moved to Kali 2025.4.

