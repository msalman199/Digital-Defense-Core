#!/bin/bash

# SSH Login Monitor Script
# This script monitors SSH login attempts and alerts on suspicious activity

LOG_FILE="/var/log/auth.log"
ALERT_FILE="$HOME/security-scripts/ssh-alerts.log"
TEMP_FILE="/tmp/ssh-check.tmp"

# Function to log alerts
log_alert() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ALERT_FILE"
}

# Function to check for failed SSH attempts
check_failed_logins() {
    echo "Checking for failed SSH login attempts..."
    
    # Get failed login attempts from the last hour
    FAILED_ATTEMPTS=$(grep "$(date '+%b %d %H')" "$LOG_FILE" | grep "Failed password" | wc -l)
    
    if [ "$FAILED_ATTEMPTS" -gt 5 ]; then
        ALERT_MSG="HIGH ALERT: $FAILED_ATTEMPTS failed SSH login attempts detected in the last hour"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
        
        # Show the failed attempts
        grep "$(date '+%b %d %H')" "$LOG_FILE" | grep "Failed password" | tail -10 >> "$ALERT_FILE"
    else
        echo "Normal activity: $FAILED_ATTEMPTS failed attempts in the last hour"
    fi
}

# Function to check for successful logins
check_successful_logins() {
    echo "Checking for successful SSH logins..."
    
    # Get successful login attempts from the last hour
    SUCCESSFUL_LOGINS=$(grep "$(date '+%b %d %H')" "$LOG_FILE" | grep "Accepted" | wc -l)
    
    if [ "$SUCCESSFUL_LOGINS" -gt 0 ]; then
        echo "INFO: $SUCCESSFUL_LOGINS successful SSH logins in the last hour"
        log_alert "INFO: $SUCCESSFUL_LOGINS successful SSH logins detected"
        
        # Log the successful attempts
        grep "$(date '+%b %d %H')" "$LOG_FILE" | grep "Accepted" >> "$ALERT_FILE"
    fi
}

# Function to check for unusual login times
check_unusual_times() {
    CURRENT_HOUR=$(date '+%H')
    
    # Check if login attempts are happening during unusual hours (midnight to 6 AM)
    if [ "$CURRENT_HOUR" -ge 0 ] && [ "$CURRENT_HOUR" -le 6 ]; then
        NIGHT_ATTEMPTS=$(grep "$(date '+%b %d')" "$LOG_FILE" | grep -E "(0[0-6]):" | grep -E "(Failed|Accepted)" | wc -l)
        
        if [ "$NIGHT_ATTEMPTS" -gt 0 ]; then
            ALERT_MSG="SUSPICIOUS: $NIGHT_ATTEMPTS login attempts during unusual hours (00:00-06:00)"
            echo "$ALERT_MSG"
            log_alert "$ALERT_MSG"
        fi
    fi
}

# Main execution
echo "=== SSH Security Monitor Started at $(date) ==="
log_alert "SSH Security Monitor Started"

check_failed_logins
check_successful_logins
check_unusual_times

echo "=== SSH Security Monitor Completed ==="
echo "Check $ALERT_FILE for detailed alerts"
