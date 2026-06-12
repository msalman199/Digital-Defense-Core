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
