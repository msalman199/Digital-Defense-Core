#!/bin/bash

# IP-based access control (simulate Windows Firewall IP restrictions)

# Define trusted networks
ADMIN_NETWORK="192.168.1.0/24"
HR_NETWORK="192.168.2.0/24"
GUEST_NETWORK="192.168.100.0/24"

echo "Configuring IP-based access control..."

# Allow administrative access from admin network only
sudo iptables -A INPUT -s $ADMIN_NETWORK -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -s $ADMIN_NETWORK -p tcp --dport 3389 -j ACCEPT

# Allow HR network access to specific services
sudo iptables -A INPUT -s $HR_NETWORK -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -s $HR_NETWORK -p tcp --dport 443 -j ACCEPT

# Restrict guest network access
sudo iptables -A INPUT -s $GUEST_NETWORK -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -s $GUEST_NETWORK -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -s $GUEST_NETWORK -j DROP

# Block known malicious IP ranges (example)
sudo iptables -A INPUT -s 10.0.0.0/8 -j DROP
sudo iptables -A INPUT -s 172.16.0.0/12 -j DROP

echo "IP-based access control configured!"
