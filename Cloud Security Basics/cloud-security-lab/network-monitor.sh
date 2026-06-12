#!/bin/bash

LOG_FILE="/opt/cloud-security-lab/logs/network-monitor.log"
ALERT_FILE="/opt/cloud-security-lab/logs/security-alerts.log"

# Function to monitor network connections
monitor_connections() {
    echo "=== Network Connection Monitor - $(date) ===" >> "$LOG_FILE"
    
    # Monitor active connections
    netstat -tuln >> "$LOG_FILE"
    
    # Check for suspicious connections
    SUSPICIOUS_PORTS=(23 135 139 445 1433 3389)
    
    for port in "${SUSPICIOUS_PORTS[@]}"; do
        if netstat -tuln | grep -q ":$port "; then
            echo "ALERT: Suspicious port $port is open - $(date)" >> "$ALERT_FILE"
        fi
    done
    
    # Monitor failed login attempts
    FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log | tail -10)
    if [ ! -z "$FAILED_LOGINS" ]; then
        echo "=== Recent Failed Login Attempts ===" >> "$LOG_FILE"
        echo "$FAILED_LOGINS" >> "$LOG_FILE"
    fi
}

# Function to check system security
check_security() {
    echo "=== Security Check - $(date) ===" >> "$LOG_FILE"
    
    # Check for users with empty passwords
    awk -F: '($2 == "") {print "WARNING: User " $1 " has empty password"}' /etc/shadow >> "$LOG_FILE"
    
    # Check for world-writable files
    find /etc -type f -perm -002 -exec echo "WARNING: World-writable file: {}" \; >> "$LOG_FILE" 2>/dev/null
    
    # Check running services
    systemctl list-units --type=service --state=running >> "$LOG_FILE"
}

# Run monitoring functions
monitor_connections
check_security

echo "Network monitoring completed. Check $LOG_FILE for details."
