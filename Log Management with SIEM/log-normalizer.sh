#!/bin/bash

# Log Normalization Script
# TODO: Complete the implementation

INPUT_DIR="/var/log"
OUTPUT_DIR="$HOME/siem-analysis/normalized"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $OUTPUT_DIR

# Function to normalize auth logs to JSON
normalize_auth_logs() {
    local output_file="$OUTPUT_DIR/auth_normalized_$DATE.json"
    
    # TODO: Read auth.log line by line
    # TODO: Extract timestamp, host, event type, user, IP
    # TODO: Convert to JSON format with fields:
    #   - timestamp
    #   - event_type (auth_failure, auth_success, privilege_escalation)
    #   - user
    #   - source_ip
    #   - severity (high, medium, low)
    #   - category
    # TODO: Write to output file
    
    echo "Auth logs normalized to: $output_file"
}

# Function to normalize web logs to JSON
normalize_web_logs() {
    local output_file="$OUTPUT_DIR/web_normalized_$DATE.json"
    
    # TODO: Read Apache access.log line by line
    # TODO: Parse Apache combined log format
    # TODO: Convert to JSON with fields:
    #   - timestamp
    #   - source_ip
    #   - method
    #   - url
    #   - status_code
    #   - user_agent
    #   - severity (based on status code)
    # TODO: Write to output file
    
    echo "Web logs normalized to: $output_file"
}

# Function to create summary
create_summary() {
    # TODO: Count events by type
    # TODO: Count events by severity
    # TODO: Generate summary report
    echo "Summary created"
}

# TODO: Execute all normalization functions

echo "Log normalization complete"
