#!/bin/bash

# Cloud Security Policy Manager
# Simulates IAM-like policy enforcement

POLICY_DIR="/opt/cloud-security-lab/policies"
LOG_FILE="/opt/cloud-security-lab/logs/access.log"

# Function to create a policy file
create_policy() {
    local role=$1
    local permissions=$2
    local policy_file="$POLICY_DIR/${role}-policy.json"
    
    cat > "$policy_file" << EOL
{
    "Version": "2023-01-01",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": $permissions,
            "Resource": "*",
            "Principal": {
                "User": "$role"
            }
        }
    ]
}
EOL
    echo "Policy created for $role at $policy_file"
}

# Function to check if user has permission
check_permission() {
    local user=$1
    local action=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log the access attempt
    echo "$timestamp - User: $user, Action: $action, Status: CHECKED" >> "$LOG_FILE"
    
    # Simple permission check based on group membership
    if groups "$user" | grep -q "cloud-admins"; then
        echo "ALLOW: $user has admin privileges for $action"
        return 0
    elif groups "$user" | grep -q "cloud-developers" && [[ "$action" == "develop"* ]]; then
        echo "ALLOW: $user has developer privileges for $action"
        return 0
    elif groups "$user" | grep -q "cloud-users" && [[ "$action" == "read"* ]]; then
        echo "ALLOW: $user has read privileges for $action"
        return 0
    elif groups "$user" | grep -q "cloud-auditors" && [[ "$action" == "audit"* ]]; then
        echo "ALLOW: $user has audit privileges for $action"
        return 0
    else
        echo "DENY: $user does not have privileges for $action"
        return 1
    fi
}

# Create default policies
create_policy "cloud-admin" '["*"]'
create_policy "cloud-developer" '["develop:*", "read:*"]'
create_policy "cloud-readonly" '["read:*"]'
create_policy "cloud-auditor" '["audit:*", "read:logs"]'

echo "Policy manager initialized successfully"
