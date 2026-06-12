#!/bin/bash

echo "=== IMPLEMENTING CONTAINMENT MEASURES ==="
echo "Containment Start Time: $(date)"

# Backup current iptables rules
sudo iptables-save > iptables_backup.txt
echo "Firewall rules backed up to iptables_backup.txt"

# Block suspicious ports immediately
echo "Blocking suspicious port 8080..."
sudo iptables -A INPUT -p tcp --dport 8080 -j DROP
sudo iptables -A OUTPUT -p tcp --dport 8080 -j DROP

echo "Blocking suspicious port 9999..."
sudo iptables -A INPUT -p tcp --dport 9999 -j DROP
sudo iptables -A OUTPUT -p tcp --dport 9999 -j DROP

# Block specific suspicious IP ranges (simulated external threats)
echo "Blocking suspicious IP ranges..."
sudo iptables -A INPUT -s 192.168.100.0/24 -j DROP
sudo iptables -A OUTPUT -d 192.168.100.0/24 -j DROP

# Log dropped packets for analysis
sudo iptables -A INPUT -j LOG --log-prefix "INCIDENT_BLOCKED: "
sudo iptables -A OUTPUT -j LOG --log-prefix "INCIDENT_BLOCKED: "

echo "Containment measures implemented successfully"
echo "Containment End Time: $(date)"
