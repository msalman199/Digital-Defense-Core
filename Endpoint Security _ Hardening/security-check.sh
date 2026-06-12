#!/bin/bash

# Master Security Check Script
# Runs all security monitoring scripts

SCRIPT_DIR="$HOME/security-scripts"
LOG_FILE="$SCRIPT_DIR/security-master.log"

echo "=== Security Check Started at $(date) ===" >> "$LOG_FILE"

# Run SSH monitor
echo "Running SSH Monitor..." >> "$LOG_FILE"
"$SCRIPT_DIR/ssh-monitor.sh" >> "$LOG_FILE" 2>&1

echo "" >> "$LOG_FILE"

# Run System monitor
echo "Running System Monitor..." >> "$LOG_FILE"
"$SCRIPT_DIR/system-monitor.sh" >> "$LOG_FILE" 2>&1

echo "=== Security Check Completed at $(date) ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Keep only last 1000 lines of log to prevent it from growing too large
tail -1000 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
