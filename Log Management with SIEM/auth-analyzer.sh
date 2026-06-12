#!/bin/bash

# Authentication Log Analyzer
# TODO: Complete the implementation

LOG_FILE="/var/log/auth.log"
OUTPUT_DIR="$HOME/siem-analysis"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $OUTPUT_DIR

# Function to analyze failed logins
analyze_failed_logins() {
    # TODO: Extract failed login attempts
    # TODO: Count attempts per IP
    # TODO: Sort by frequency
    # TODO: Save to output file
    echo "Analyzing failed logins..."
}

# Function to detect brute force attacks
detect_brute_force() {
    # TODO: Identify IPs with >5 failed attempts
    # TODO: Extract timestamp, IP, and username
    # TODO: Generate alert report
    echo "Detecting brute force attempts..."
}

# Function to analyze sudo usage
analyze_sudo_usage() {
    # TODO: Extract sudo commands
    # TODO: Identify users and commands executed
    # TODO: Generate usage report
    echo "Analyzing sudo usage..."
}

# TODO: Call all analysis functions
# TODO: Generate summary report

echo "Analysis complete. Results in: $OUTPUT_DIR"
