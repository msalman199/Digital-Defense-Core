# 🖥️ Virtualization Security 

![KVM](https://img.shields.io/badge/KVM-Virtualization-brightgreen?style=for-the-badge&logo=linux&logoColor=white)
![QEMU](https://img.shields.io/badge/QEMU-Emulator-red?style=for-the-badge&logo=qemu&logoColor=white)
![Libvirt](https://img.shields.io/badge/Libvirt-VM%20Management-orange?style=for-the-badge&logo=linux&logoColor=white)
![AppArmor](https://img.shields.io/badge/AppArmor-Security-purple?style=for-the-badge&logo=linux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-FCC624?style=for-the-badge&logo=linux&logoColor=black)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

- ⚙️ Install and configure **KVM virtualization** with security hardening
- 🔒 Implement **security controls** for virtual machines
- 📸 Create **automated snapshot management** systems
- 💾 Develop **backup and recovery procedures** for VMs
- 🛡️ Apply **security best practices** to virtualization infrastructure

---

## ✅ Prerequisites

| Requirement | Description |
|---|---|
| 🖥️ Linux CLI | Basic Linux command line proficiency |
| 💡 Virtualization | Understanding of virtualization concepts |
| 🐚 Shell Scripting | Familiarity with shell scripting |
| 🔑 Sudo Access | Access to a Linux system with sudo privileges |

---

## 🧪 Lab Environment

> 💡 **Al Nafi** provides Linux-based cloud machines for this lab.  
> Click **Start Lab** to access your pre-configured environment.  
> All activities will be performed on the provided Linux machine with **KVM support enabled**.

---

# 📋 Task 1 — Installing and Configuring Secure KVM Environment

![KVM](https://img.shields.io/badge/KVM-Install%20%26%20Configure-brightgreen?style=flat-square)
![Network](https://img.shields.io/badge/Virtual-Network%20Security-blue?style=flat-square)
![Libvirt](https://img.shields.io/badge/Libvirt-Security%20Settings-orange?style=flat-square)

---

## 📦 Step 1.1 — Install KVM Components

🔄 **Update system packages:**

```bash
sudo apt update && sudo apt upgrade -y
```

📥 **Install KVM and management tools:**

```bash
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients \
    bridge-utils virt-manager virtinst
```

✅ **Verify installation:**

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo   # Should return > 0
lsmod | grep kvm                      # Should show kvm modules
```

👤 **Add user to libvirt group:**

```bash
sudo usermod -a -G libvirt $USER
newgrp libvirt
```

---

## 🌐 Step 1.2 — Configure Secure Virtual Network

📁 **Create network configuration directory:**

```bash
sudo mkdir -p /etc/libvirt/qemu/networks
```

📄 **Create secure network definition:**

```bash
sudo tee /etc/libvirt/qemu/networks/secure-net.xml > /dev/null << 'EOF'
<network>
  <name>secure-net</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr1' stp='on' delay='0'/>
  <ip address='192.168.100.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.100.100' end='192.168.100.200'/>
    </dhcp>
  </ip>
</network>
EOF
```

🚀 **Define and activate the network:**

```bash
sudo virsh net-define /etc/libvirt/qemu/networks/secure-net.xml
sudo virsh net-start secure-net
sudo virsh net-autostart secure-net
```

✅ **Verify network creation:**

```bash
virsh net-list --all
```

---

## 🔒 Step 1.3 — Configure Libvirt Security Settings

💾 **Backup original configuration:**

```bash
sudo cp /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.backup
```

📄 **Apply security configurations:**

```bash
sudo tee -a /etc/libvirt/qemu.conf > /dev/null << 'EOF'

# Security settings
security_driver = "apparmor"
security_default_confined = 1
security_require_confined = 1

# Network security
clear_emulator_capabilities = 1

# User and group settings
user = "libvirt-qemu"
group = "libvirt-qemu"
EOF
```

🔄 **Restart libvirt to apply changes:**

```bash
sudo systemctl restart libvirtd
sudo systemctl status libvirtd
```

---

# 📋 Task 2 — Creating and Hardening Virtual Machines

![Hardening](https://img.shields.io/badge/VM-Hardening%20Script-red?style=flat-square)
![AppArmor](https://img.shields.io/badge/AppArmor-Profile-purple?style=flat-square)
![CPU](https://img.shields.io/badge/CPU-Security%20Features-blue?style=flat-square)

---

## 🛡️ Step 2.1 — Create VM Hardening Script Template

📁 **Create script directory:**

```bash
mkdir -p ~/vm-security
```

✏️ **Create hardening script template:**

```bash
cat > ~/vm-security/harden-vm.sh << 'EOF'
#!/bin/bash

# VM Hardening Script Template
# Students: Complete the TODO sections to implement security hardening

set -e

VM_NAME="$1"

# Function: Validate VM exists
check_vm_exists() {
    # TODO: Implement VM existence check using virsh
    # Hint: Use 'virsh list --all' and grep
    pass
}

# Function: Apply CPU security features
harden_cpu() {
    echo "Hardening CPU configuration..."
    
    # TODO: Dump VM XML configuration
    # TODO: Add CPU security features (spec-ctrl, ssbd)
    # TODO: Apply updated configuration
    # Hint: Use virsh dumpxml, sed, and virsh define
    
    echo "CPU hardening completed"
}

# Function: Secure network configuration
harden_network() {
    echo "Securing network configuration..."
    
    # TODO: Create network filter for traffic control
    # TODO: Apply filter to VM network interface
    # Filters to implement: no-mac-spoofing, no-ip-spoofing, no-arp-spoofing
    
    echo "Network hardening completed"
}

# Function: Configure secure storage
harden_storage() {
    echo "Configuring secure storage..."
    
    # TODO: Set disk cache mode to 'none' for security
    # TODO: Enable discard/trim support
    # TODO: Apply updated disk configuration
    
    echo "Storage hardening completed"
}

# Function: Apply AppArmor security profile
apply_apparmor() {
    echo "Applying AppArmor security..."
    
    # TODO: Add AppArmor seclabel to VM configuration
    # TODO: Set type='dynamic' model='apparmor' relabel='yes'
    
    echo "AppArmor configuration completed"
}

# Main execution
main() {
    if [ -z "$VM_NAME" ]; then
        echo "Usage: $0 <vm-name>"
        exit 1
    fi
    
    check_vm_exists
    
    # Stop VM if running
    if virsh list | grep -q "$VM_NAME"; then
        echo "Stopping VM for hardening..."
        virsh shutdown "$VM_NAME"
        sleep 10
    fi
    
    # TODO: Call all hardening functions
    # harden_cpu
    # harden_network
    # harden_storage
    # apply_apparmor
    
    echo "VM hardening completed for: $VM_NAME"
}

main
EOF

chmod +x ~/vm-security/harden-vm.sh
```

> **🔐 Hardening Functions to Implement:**

| Function | Description |
|---|---|
| 🧠 `harden_cpu()` | Add `spec-ctrl` and `ssbd` CPU security features |
| 🌐 `harden_network()` | Apply no-MAC/IP/ARP spoofing filters |
| 💾 `harden_storage()` | Set cache mode to `none`, enable trim/discard |
| 🛡️ `apply_apparmor()` | Apply dynamic AppArmor security label |

---

## 🖥️ Step 2.2 — Create Test VM

💽 **Create VM disk image:**

```bash
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/test-vm.qcow2 5G
```

📄 **Create basic VM definition:**

```bash
cat > ~/vm-security/test-vm.xml << 'EOF'
<domain type='kvm'>
  <name>test-vm</name>
  <memory unit='KiB'>1048576</memory>
  <vcpu placement='static'>1</vcpu>
  <os>
    <type arch='x86_64' machine='pc'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
  </features>
  <cpu mode='host-model'/>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/test-vm.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <interface type='network'>
      <source network='secure-net'/>
      <model type='virtio'/>
    </interface>
    <graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1'/>
  </devices>
</domain>
EOF
```

🚀 **Define the VM and verify:**

```bash
sudo virsh define ~/vm-security/test-vm.xml
virsh list --all
```

---

## 🧪 Step 2.3 — Test Hardening Script

▶️ **Run hardening script** *(complete implementation first)*:

```bash
~/vm-security/harden-vm.sh test-vm
```

✅ **Verify hardened configuration:**

```bash
virsh dumpxml test-vm | grep -A 5 "cpu\|seclabel\|filterref"
```

> 📝 Review the VM configuration and document the security features applied.

---

# 📋 Task 3 — Implementing Snapshot Management

![Snapshots](https://img.shields.io/badge/Snapshot-Manager-blue?style=flat-square)
![Automation](https://img.shields.io/badge/Automated-Cleanup-orange?style=flat-square)
![Recovery](https://img.shields.io/badge/Point--in--Time-Recovery-green?style=flat-square)

---

## 📸 Step 3.1 — Create Snapshot Manager Script Template

✏️ **Create the snapshot manager:**

```bash
cat > ~/vm-security/snapshot-manager.sh << 'EOF'
#!/bin/bash

# VM Snapshot Manager Template
# Students: Complete the TODO sections

COMMAND="$1"
VM_NAME="$2"
SNAPSHOT_NAME="$3"

# Function: Create snapshot
create_snapshot() {
    local vm="$1"
    local snap_name="$2"
    
    # Generate name if not provided
    if [ -z "$snap_name" ]; then
        snap_name="auto-$(date '+%Y%m%d-%H%M%S')"
    fi
    
    echo "Creating snapshot: $snap_name for VM: $vm"
    
    # TODO: Implement snapshot creation
    # Hint: Use 'virsh snapshot-create-as' with --atomic flag
    # Include description with timestamp
    
    echo "Snapshot created successfully"
}

# Function: List snapshots
list_snapshots() {
    local vm="$1"
    
    echo "Snapshots for VM: $vm"
    
    # TODO: List all snapshots with details
    # Hint: Use 'virsh snapshot-list' with --tree option
    # Show creation time and description
}

# Function: Restore snapshot
restore_snapshot() {
    local vm="$1"
    local snap_name="$2"
    
    if [ -z "$snap_name" ]; then
        echo "ERROR: Snapshot name required"
        exit 1
    fi
    
    echo "Restoring VM: $vm to snapshot: $snap_name"
    
    # TODO: Implement snapshot restoration
    # Stop VM if running
    # Use 'virsh snapshot-revert'
    # Handle errors appropriately
}

# Function: Delete snapshot
delete_snapshot() {
    local vm="$1"
    local snap_name="$2"
    
    # TODO: Implement snapshot deletion
    # Verify snapshot exists before deletion
    # Use 'virsh snapshot-delete'
}

# Function: Cleanup old snapshots
cleanup_old_snapshots() {
    local vm="$1"
    local keep_count="${2:-3}"  # Default: keep 3 most recent
    
    echo "Cleaning up old snapshots, keeping last $keep_count"
    
    # TODO: Implement cleanup logic
    # Get list of snapshots sorted by date
    # Delete oldest snapshots beyond keep_count
    # Preserve most recent snapshots
}

# Main execution
case "$COMMAND" in
    create)
        create_snapshot "$VM_NAME" "$SNAPSHOT_NAME"
        ;;
    list)
        list_snapshots "$VM_NAME"
        ;;
    restore)
        restore_snapshot "$VM_NAME" "$SNAPSHOT_NAME"
        ;;
    delete)
        delete_snapshot "$VM_NAME" "$SNAPSHOT_NAME"
        ;;
    cleanup)
        cleanup_old_snapshots "$VM_NAME" "$SNAPSHOT_NAME"
        ;;
    *)
        echo "Usage: $0 {create|list|restore|delete|cleanup} <vm-name> [snapshot-name]"
        exit 1
        ;;
esac
EOF

chmod +x ~/vm-security/snapshot-manager.sh
```

> **📸 Snapshot Functions to Implement:**

| Function | Command Hint | Description |
|---|---|---|
| 📸 `create_snapshot()` | `virsh snapshot-create-as --atomic` | Create atomic snapshot with timestamp |
| 📋 `list_snapshots()` | `virsh snapshot-list --tree` | List all snapshots with tree view |
| 🔁 `restore_snapshot()` | `virsh snapshot-revert` | Revert VM to a previous snapshot |
| 🗑️ `delete_snapshot()` | `virsh snapshot-delete` | Delete a named snapshot |
| 🧹 `cleanup_old_snapshots()` | Date-sorted deletion | Keep N most recent, delete older |

---

## 🧪 Step 3.2 — Test Snapshot Operations

🧪 **Create test snapshots:**

```bash
~/vm-security/snapshot-manager.sh create test-vm "baseline"
~/vm-security/snapshot-manager.sh create test-vm "pre-update"
```

📋 **List all snapshots:**

```bash
~/vm-security/snapshot-manager.sh list test-vm
```

🔁 **Test restoration** *(implement first)*:

```bash
# ~/vm-security/snapshot-manager.sh restore test-vm "baseline"
```

🧹 **Test cleanup** *(implement first)*:

```bash
# ~/vm-security/snapshot-manager.sh cleanup test-vm 2
```

---

# 📋 Task 4 — Developing Backup Automation

![Backup](https://img.shields.io/badge/Backup-Manager-darkgreen?style=flat-square)
![Recovery](https://img.shields.io/badge/Restore-Recovery-blue?style=flat-square)
![Cron](https://img.shields.io/badge/Cron-Automated%20Schedule-orange?style=flat-square)

---

## 💾 Step 4.1 — Create Backup Manager Script Template

✏️ **Create the backup manager:**

```bash
cat > ~/vm-security/backup-manager.sh << 'EOF'
#!/bin/bash

# VM Backup Manager Template
# Students: Complete the TODO sections

BACKUP_DIR="/var/backups/vm-backups"
LOG_FILE="/var/log/vm-backups.log"

# Function: Setup backup environment
setup_backup_env() {
    # TODO: Create backup directory structure
    # Create subdirectories: full, incremental, metadata
    # Set appropriate permissions
    
    sudo mkdir -p "$BACKUP_DIR"/{full,incremental,metadata}
}

# Function: Log messages
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | sudo tee -a "$LOG_FILE"
}

# Function: Get VM disk path
get_vm_disk_path() {
    local vm="$1"
    
    # TODO: Extract disk path from VM XML
    # Hint: Use virsh dumpxml and grep/awk
    # Return the primary disk path
}

# Function: Create full backup
create_full_backup() {
    local vm="$1"
    local backup_name="backup-$(date '+%Y%m%d-%H%M%S')"
    
    log_message "Starting full backup for VM: $vm"
    
    # TODO: Implement full backup process
    # 1. Check if VM is running
    # 2. Export VM XML configuration
    # 3. Create disk backup (handle live vs offline)
    # 4. Compress backup (optional)
    # 5. Create metadata file with backup info
    
    # For live backups, use external snapshots:
    # - Create external snapshot
    # - Copy original disk
    # - Merge snapshot back
    
    log_message "Backup completed: $backup_name"
    echo "$backup_name"
}

# Function: Restore from backup
restore_backup() {
    local vm="$1"
    local backup_name="$2"
    
    log_message "Restoring VM: $vm from backup: $backup_name"
    
    # TODO: Implement restore process
    # 1. Verify backup exists
    # 2. Stop VM if running
    # 3. Restore disk image
    # 4. Restore VM configuration
    # 5. Verify restoration
    
    log_message "Restore completed for VM: $vm"
}

# Function: List available backups
list_backups() {
    local vm="$1"
    
    echo "Available backups for VM: $vm"
    
    # TODO: List all backups with details
    # Show: backup name, date, size, type
    # Read from metadata files
}

# Function: Cleanup old backups
cleanup_old_backups() {
    local vm="$1"
    local retention_days="${2:-30}"
    
    log_message "Cleaning up backups older than $retention_days days"
    
    # TODO: Implement cleanup logic
    # Find backups older than retention period
    # Delete old backup files and metadata
    # Log deletion actions
}

# Function: Verify backup integrity
verify_backup() {
    local backup_name="$1"
    
    echo "Verifying backup: $backup_name"
    
    # TODO: Implement verification
    # Check file integrity
    # Verify disk image format
    # Validate metadata
    # Return success/failure status
}

# Main execution
COMMAND="$1"
VM_NAME="$2"
BACKUP_NAME="$3"

setup_backup_env

case "$COMMAND" in
    backup)
        create_full_backup "$VM_NAME"
        ;;
    restore)
        restore_backup "$VM_NAME" "$BACKUP_NAME"
        ;;
    list)
        list_backups "$VM_NAME"
        ;;
    cleanup)
        cleanup_old_backups "$VM_NAME" "$BACKUP_NAME"
        ;;
    verify)
        verify_backup "$BACKUP_NAME"
        ;;
    *)
        echo "Usage: $0 {backup|restore|list|cleanup|verify} <vm-name> [backup-name]"
        exit 1
        ;;
esac
EOF

chmod +x ~/vm-security/backup-manager.sh
```

> **💾 Backup Functions to Implement:**

| Function | Description |
|---|---|
| 🗂️ `setup_backup_env()` | Create `full/`, `incremental/`, `metadata/` dirs with permissions |
| 💾 `create_full_backup()` | XML export + disk copy + metadata file (live snapshot method) |
| 🔁 `restore_backup()` | Stop VM → restore disk → restore XML → verify |
| 📋 `list_backups()` | Read metadata files and display name/date/size/type |
| 🧹 `cleanup_old_backups()` | Delete backups beyond retention days, log deletions |
| ✅ `verify_backup()` | Check file integrity, disk image format, metadata validity |

---

## 🧪 Step 4.2 — Test Backup Operations

▶️ **Initialize backup environment:**

```bash
~/vm-security/backup-manager.sh backup test-vm
```

📋 **List backups** *(implement first)*:

```bash
# ~/vm-security/backup-manager.sh list test-vm
```

✅ **Verify backup integrity** *(implement first)*:

```bash
# ~/vm-security/backup-manager.sh verify <backup-name>
```

🔁 **Test restoration** *(implement first)*:

```bash
# ~/vm-security/backup-manager.sh restore test-vm <backup-name>
```

---

## ⏰ Step 4.3 — Create Automated Backup Schedule

✏️ **Create cron backup script:**

```bash
cat > ~/vm-security/backup-cron.sh << 'EOF'
#!/bin/bash

# Automated Backup Cron Script
# Students: Customize for your environment

# TODO: Add logic to backup all VMs
# Loop through all VMs
# Create backups with error handling
# Send notifications on failure
# Cleanup old backups automatically

# Example structure:
# for vm in $(virsh list --name --all); do
#     ~/vm-security/backup-manager.sh backup "$vm"
# done
# ~/vm-security/backup-manager.sh cleanup test-vm 30
EOF

chmod +x ~/vm-security/backup-cron.sh
```

⏱️ **Add to crontab for daily backups at 2 AM:**

```bash
crontab -e
```

➕ **Add the following line:**

```bash
0 2 * * * /home/$USER/vm-security/backup-cron.sh
```

---

# ✅ Expected Outcomes

After completing this lab, students should have:

- ✅ **Functional KVM environment** with security hardening applied
- ✅ **Working VM hardening script** with CPU, network, storage, and AppArmor controls
- ✅ **Automated snapshot management** system with create/list/restore/cleanup
- ✅ **Comprehensive backup and recovery** solution with scheduling
- ✅ Understanding of **virtualization security best practices**

---

# 🔧 Troubleshooting Tips

<details>
<summary>🔴 KVM modules not loading</summary>

Verify CPU virtualization support:

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

> If result is `0`, enable virtualization (VT-x/AMD-V) in BIOS/UEFI settings.

</details>

<details>
<summary>🔴 Permission denied errors with virsh</summary>

Ensure user is in the libvirt group:

```bash
sudo usermod -a -G libvirt $USER
```

Then logout/login or apply immediately:

```bash
newgrp libvirt
```

</details>

<details>
<summary>🔴 Snapshot creation fails</summary>

- Ensure VM disk format supports snapshots — must be `qcow2` not `raw`
- Check available disk space: `df -h /var/lib/libvirt/images/`
- Verify VM is not in a transient state: `virsh list --all`

</details>

<details>
<summary>🔴 Backup script fails for running VMs</summary>

- Implement proper **live backup with external snapshots**
- Ensure sufficient disk space for temporary snapshots
- Handle `blockcommit` operations correctly after snapshot copy

</details>

---

# 🎓 Conclusion

This lab provided hands-on experience with **virtualization security**, covering KVM installation, VM hardening, snapshot management, and backup automation. Here's a summary of key accomplishments:

| Area | Achievement |
|---|---|
| ⚙️ KVM Setup | Installed and secured KVM with AppArmor and libvirt hardening |
| 🌐 Virtual Network | Isolated NAT network with DHCP and STP bridge |
| 🛡️ VM Hardening | CPU, network, storage, and AppArmor security controls |
| 📸 Snapshot Manager | Full CRUD snapshot operations with automated cleanup |
| 💾 Backup Automation | Full backup, restore, verify, and cron scheduling |

---

## 💡 Key Takeaways

| # | Takeaway |
|---|---|
| 🔒 | **AppArmor confinement** reduces the blast radius of compromised VMs |
| 🌐 | **Network filters** prevent MAC/IP/ARP spoofing inside virtual networks |
| 📸 | **Regular snapshots** enable fast rollback from security incidents |
| 💾 | **Automated backups** with retention policies protect against data loss |
| 🧱 | **Layered hardening** — CPU, network, storage, and OS-level controls |
| 🔁 | **Always test restores** — an untested backup is not a backup |

---

## 🚀 Next Steps

![SELinux](https://img.shields.io/badge/Next-SELinux%20Hardening-red?style=flat-square)
![VLAN](https://img.shields.io/badge/Next-VLAN%20Segmentation-blue?style=flat-square)
![Ansible](https://img.shields.io/badge/Next-Ansible%20Automation-black?style=flat-square&logo=ansible&logoColor=white)
![Cloud](https://img.shields.io/badge/Next-Cloud%20Security-orange?style=flat-square&logo=cloudflare&logoColor=white)

- 🔴 Explore **SELinux** as an alternative to AppArmor for VM confinement
- 🔵 Study **VLAN segmentation** for advanced virtual network isolation
- ⚫ Automate VM provisioning and hardening with **Ansible**
- 🟠 Apply these concepts to **cloud security** on AWS/Azure/GCP

---

<div align="center">

![Made with](https://img.shields.io/badge/Made%20with-❤️%20for%20Security-blueviolet?style=for-the-badge)
![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Lab%20Guide-0077B5?style=for-the-badge)

</div>
