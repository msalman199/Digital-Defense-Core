#!/bin/bash

BACKUP_DIR="/opt/cloud-security-lab/backups"
SOURCE_DIR="/opt/cloud-security-lab"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="security-backup-$TIMESTAMP"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to create encrypted backup
create_backup() {
    echo "Creating secure backup: $BACKUP_NAME"
    
    # Create tar archive
    tar -czf "/tmp/${BACKUP_NAME}.tar.gz" -C "$SOURCE_DIR" \
        --exclude="backups" \
        --exclude="*.log" \
        policies users keys
    
    # Encrypt the backup
    /opt/cloud-security-lab/key-manager.sh encrypt_file "/tmp/${BACKUP_NAME}.tar.gz" backup-encryption
    
    # Move encrypted backup to backup directory
    mv "/tmp/${BACKUP_NAME}.tar.gz.encrypted" "$BACKUP_DIR/"
    
    # Clean up temporary file
    rm -f "/tmp/${BACKUP_NAME}.tar.gz"
    
    # Create backup manifest
    cat > "$BACKUP_DIR/${BACKUP_NAME}-manifest.txt" << EOL
Backup Name: $BACKUP_NAME
Created: $(date)
Source: $SOURCE_DIR
Encryption: AES-256-CBC
Key: backup-encryption
Size: $(du -h "$BACKUP_DIR/${BACKUP_NAME}.tar.gz.encrypted" | cut -f1)
Checksum: $(sha256sum "$BACKUP_DIR/${BACKUP_NAME}.tar.gz.encrypted" | cut -d' ' -f1)
EOL
    
    echo "Backup created successfully: $BACKUP_DIR/${BACKUP_NAME}.tar.gz.encrypted"
}

# Function to restore from backup
restore_backup() {
    local backup_file=$1
    local restore_dir="/tmp/restore-$TIMESTAMP"
    
    if [ ! -f "$backup_file" ]; then
        echo "Error: Backup file not found: $backup_file"
        return 1
    fi
    
    echo "Restoring from backup: $backup_file"
    
    # Create restore directory
    mkdir -p "$restore_dir"
    
    # Decrypt the backup
    /opt/cloud-security-lab/key-manager.sh decrypt_file "$backup_file" backup-encryption
    
    # Extract the backup
    tar -xzf "${backup_file%.encrypted}.decrypted" -C "$restore_dir"
    
    echo "Backup restored to: $restore_dir"
    ls -la "$restore_dir"
}

# Function to list available backups
list_backups() {
    echo "Available backups:"
    ls -la "$BACKUP_DIR"/*.encrypted 2>/dev/null || echo "No backups found"
}

# Main execution
case "$1" in
    "create")
        create_backup
        ;;
    "restore")
        restore_backup "$2"
        ;;
    "list")
        list_backups
        ;;
    *)
        echo "Usage: $0 {create|restore <backup_file>|list}"
        exit 1
        ;;
esac
