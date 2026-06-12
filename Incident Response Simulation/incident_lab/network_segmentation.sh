#!/bin/bash

echo "=== IMPLEMENTING NETWORK SEGMENTATION ==="
echo "Segmentation Start Time: $(date)"

# Create isolated network zones using iptables
echo "Creating network segmentation rules..."

# Quarantine zone - block all traffic except essential services
sudo iptables -N QUARANTINE_ZONE
sudo iptables -A QUARANTINE_ZONE -p tcp --dport 22 -j ACCEPT  # SSH for management
sudo iptables -A QUARANTINE_ZONE -p tcp --dport 53 -j ACCEPT  # DNS
sudo iptables -A QUARANTINE_ZONE -p udp --dport 53 -j ACCEPT  # DNS
sudo iptables -A QUARANTINE_ZONE -j DROP

# Secure zone - allow only necessary business traffic
sudo iptables -N SECURE_ZONE
sudo iptables -A SECURE_ZONE -p tcp --dport 80 -j ACCEPT   # HTTP
sudo iptables -A SECURE_ZONE -p tcp --dport 443 -j ACCEPT  # HTTPS
sudo iptables -A SECURE_ZONE -p tcp --dport 22 -j ACCEPT   # SSH
sudo iptables -A SECURE_ZONE -p tcp --dport 53 -j ACCEPT   # DNS
sudo iptables -A SECURE_ZONE -p udp --dport 53 -j ACCEPT   # DNS
sudo iptables -A SECURE_ZONE -j DROP

# Apply segmentation to localhost (simulating network segments)
sudo iptables -A INPUT -s 127.0.0.1 -j SECURE_ZONE

echo "Network segmentation implemented successfully"
echo "Segmentation End Time: $(date)"
