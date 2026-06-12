#!/bin/bash

# System Access Monitor Script
# Monitors various system access points and user activities

ALERT_FILE="$HOME/security-scripts/system-alerts.log"
LOG_FILE="/var/log/auth.log"

# Function to log alerts
log_alert() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ALERT_FILE"
}

# Function to check for sudo usage
check_sudo_usage() {
    echo "Checking sudo usage..."
    
    SUDO_ATTEMPTS=$(grep "$(date '+%b %d')" "$LOG_FILE" | grep "sudo" | wc -l)
    
    if [ "$SUDO_ATTEMPTS" -gt 10 ]; then
        ALERT_MSG="WARNING: High sudo usage detected - $SUDO_ATTEMPTS attempts today"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
    else
        echo "Normal sudo usage: $SUDO_ATTEMPTS attempts today"
    fi
}

# Function to check for new user accounts
check_new_users() {
    echo "Checking for recently created user accounts..."
    
    # Check for users created in the last 24 hours
    RECENT_USERS=$(find /home -maxdepth 1 -type d -newerct "1 day ago" | grep -v "^/home$" | wc -l)
    
    if [ "$RECENT_USERS" -gt 0 ]; then
        ALERT_MSG="ALERT: $RECENT_USERS new user directories detected in the last 24 hours"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
        
        # List the new directories
        find /home -maxdepth 1 -type d -newerct "1 day ago" | grep -v "^/home$" >> "$ALERT_FILE"
    fi
}

# Function to check for failed su attempts
check_su_attempts() {
    echo "Checking for su (switch user) attempts..."
    
    SU_FAILURES=$(grep "$(date '+%b %d')" "$LOG_FILE" | grep "su:" | grep "FAILED" | wc -l)
    
    if [ "$SU_FAILURES" -gt 0 ]; then
        ALERT_MSG="WARNING: $SU_FAILURES failed su attempts detected today"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
    fi
}

# Function to check system load
check_system_load() {
    echo "Checking system load..."
    
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    LOAD_THRESHOLD=2.0
    
    if (( $(echo "$LOAD_AVG > $LOAD_THRESHOLD" | bc -l) )); then
        ALERT_MSG="WARNING: High system load detected - $LOAD_AVG"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
    else
        echo "System load normal: $LOAD_AVG"
    fi
}

# Function to check disk usage
check_disk_usage() {
    echo "Checking disk usage..."
    
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "$DISK_USAGE" -gt 80 ]; then
        ALERT_MSG="WARNING: High disk usage detected - ${DISK_USAGE}%"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
    else
        echo "Disk usage normal: ${DISK_USAGE}%"
    fi
}

# Main execution
echo "=== System Security Monitor Started at $(date) ==="
log_alert "System Security Monitor Started"

check_sudo_usage
check_new_users
check_su_attempts
check_system_load
check_disk_usage

echo "=== System Security Monitor Completed ==="
echo "Check $ALERT_FILE for detailed alerts"
