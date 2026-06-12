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
