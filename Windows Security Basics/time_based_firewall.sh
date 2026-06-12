#!/bin/bash

# Time-based firewall rules (simulate Windows Firewall time restrictions)

# Allow business hours access (8 AM to 6 PM, Monday to Friday)
# Block non-business hours for certain services

CURRENT_HOUR=$(date +%H)
CURRENT_DAY=$(date +%u)  # 1=Monday, 7=Sunday

echo "Current time: $(date)"
echo "Hour: $CURRENT_HOUR, Day: $CURRENT_DAY"

# Remove existing time-based rules
sudo iptables -D INPUT -p tcp --dport 3389 -j ACCEPT 2>/dev/null || true
sudo iptables -D INPUT -p tcp --dport 3389 -j DROP 2>/dev/null || true

# RDP access (port 3389) - only during business hours on weekdays
if [ $CURRENT_DAY -ge 1 ] && [ $CURRENT_DAY -le 5 ]; then  # Monday to Friday
    if [ $CURRENT_HOUR -ge 8 ] && [ $CURRENT_HOUR -lt 18 ]; then  # 8 AM to 6 PM
        sudo iptables -A INPUT -p tcp --dport 3389 -j ACCEPT
        echo "RDP access ALLOWED (business hours)"
    else
        sudo iptables -A INPUT -p tcp --dport 3389 -j DROP
        echo "RDP access BLOCKED (outside business hours)"
    fi
else
    sudo iptables -A INPUT -p tcp --dport 3389 -j DROP
    echo "RDP access BLOCKED (weekend)"
fi
