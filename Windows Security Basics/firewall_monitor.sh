#!/bin/bash

# Firewall monitoring script

LOG_FILE="/var/log/firewall_monitor.log"
ALERT_THRESHOLD=10

echo "=== Firewall Monitor Report - $(date) ===" >> $LOG_FILE

# Count dropped packets in the last hour
DROPPED_COUNT=$(grep "FIREWALL-DROPPED" /var/log/syslog | grep "$(date '+%b %d %H')" | wc -l)
echo "Dropped packets in last hour: $DROPPED_COUNT" >> $LOG_FILE

# Check for potential attacks
if [ $DROPPED_COUNT -gt $ALERT_THRESHOLD ]; then
    echo "ALERT: High number of dropped packets detected!" >> $LOG_FILE
    echo "Potential security incident - investigate immediately" >> $LOG_FILE
fi

# Show current firewall rules
echo "Current firewall rules:" >> $LOG_FILE
sudo iptables -L -n >> $LOG_FILE

# Show connection statistics
echo "Connection statistics:" >> $LOG_FILE
ss -tuln >> $LOG_FILE

echo "=== End Report ===" >> $LOG_FILE
echo "" >> $LOG_FILE

# Display summary to console
echo "Firewall Monitor Summary:"
echo "- Dropped packets in last hour: $DROPPED_COUNT"
echo "- Log file: $LOG_FILE"
echo "- Current active rules: $(sudo iptables -L | grep -c '^ACCEPT\|^DROP\|^REJECT')"
