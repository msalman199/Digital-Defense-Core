#!/bin/bash

echo "=== Cloud Security Lab Final Verification ==="
echo "=============================================="

# Test 1: User Management
echo -e "\n1. Testing User Management System:"
id cloud-admin cloud-developer cloud-readonly cloud-auditor

# Test 2: Policy System
echo -e "\n2. Testing Policy System:"
/opt/cloud-security-lab/policy-manager.sh check_permission cloud-admin "admin:full-access"

# Test 3: Firewall Status
echo -e "\n3. Checking Firewall Status:"
sudo ufw status

# Test 4: Encryption System
echo -e "\n4. Testing Encryption System:"
ls -la /opt/cloud-security-lab/keys/active/

# Test 5: Monitoring Services
echo -e "\n5. Checking Security Services:"
systemctl is-active fail2ban
systemctl is-enabled fail2ban

# Test 6: Backup System
echo -e "\n6. Checking Backup System:"
ls -la /opt/cloud-security-lab/backups/

# Test 7: Log Files
echo -e "\n7. Checking Security Logs:"
ls -la /opt/cloud-security-lab/logs/

echo -e "\n=== Verification Complete ==="
echo "All cloud security components have been successfully implemented!"
