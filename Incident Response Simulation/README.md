# 🚨 Incident Response Simulation 

<div align="center">

# 🛡️ Cybersecurity Incident Response & Containment

![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge\&logo=ubuntu\&logoColor=white)
![Incident Response](https://img.shields.io/badge/Incident-Response-red?style=for-the-badge)
![Firewall](https://img.shields.io/badge/Firewall-IPTables-orange?style=for-the-badge)
![Network Security](https://img.shields.io/badge/Network-Security-blue?style=for-the-badge)
![TCPDump](https://img.shields.io/badge/TCPDump-Packet_Analysis-green?style=for-the-badge)
![Nmap](https://img.shields.io/badge/Nmap-Network_Scanner-00457C?style=for-the-badge)

### 🔍 Hands-On Cyber Incident Detection, Containment & Investigation Lab

</div>

---

# 📚Overview

This lab simulates a real-world cybersecurity incident where suspicious network activity has been detected inside an organization.

You will act as an Incident Response Team member responsible for:

* Detecting suspicious activity
* Collecting evidence
* Containing threats
* Implementing firewall protections
* Performing network segmentation
* Creating professional incident reports
* Verifying remediation effectiveness

---

# 🎯 Objectives

By the end of this lab, you will be able to:

✅ Understand Incident Response Fundamentals

✅ Detect Suspicious Network Activity

✅ Analyze Network Connections

✅ Implement Firewall-Based Containment

✅ Configure Network Segmentation

✅ Collect Digital Evidence

✅ Create Professional Incident Reports

✅ Verify Incident Containment

✅ Apply Security Monitoring Techniques

---

# 📋 Prerequisites

Before starting:

* Linux Command Line Basics
* Networking Fundamentals
* Firewall Concepts
* Cyber Attack Fundamentals
* Log Analysis Skills

---

# 🖥️ Lab Environment

### Al Nafi Cloud Environment

| Component        | Details               |
| ---------------- | --------------------- |
| Operating System | Ubuntu Linux          |
| Tools            | Pre-installed         |
| Environment      | Cloud Lab             |
| Privileges       | Administrative Access |

---

# 🚨 Incident Scenario

Your organization has detected:

⚠ Unauthorized Network Services

⚠ Suspicious Network Connections

⚠ Possible Data Exfiltration Attempts

⚠ Unusual Activity on Non-Standard Ports

Your mission is to contain the incident and document every response action.

---

# 🔍 Task 1: Environment Setup & Initial Assessment

---

## 🛠️ Subtask 1.1 Install Required Tools

### Update System

```bash
sudo apt update
```

### Install Incident Response Tools

```bash
sudo apt install -y \
iptables \
netstat \
ss \
tcpdump \
nmap \
ufw
```

### Verify Installations

```bash
iptables --version

ss --version

tcpdump --version

nmap --version
```

---

## 🌐 Subtask 1.2 Create Suspicious Service

### Create Lab Directory

```bash
mkdir -p ~/incident_lab

cd ~/incident_lab
```

### Create Suspicious Server

```python
#!/usr/bin/env python3

import http.server
import socketserver
import time

class SuspiciousHandler(http.server.SimpleHTTPRequestHandler):

    def do_GET(self):
        print(f"Suspicious access from {self.client_address[0]}")
        super().do_GET()

PORT = 8080

with socketserver.TCPServer(("", PORT), SuspiciousHandler) as httpd:
    print(f"Suspicious server running on port {PORT}")
    httpd.serve_forever()
```

Save as:

```bash
suspicious_server.py
```

Make executable:

```bash
chmod +x suspicious_server.py
```

Start service:

```bash
python3 suspicious_server.py &
```

---

## 📋 Subtask 1.3 Initial Network Assessment

### Create Incident Response Directory

```bash
mkdir -p ~/incident_response

cd ~/incident_response
```

### Capture Current State

```bash
echo "=== INITIAL NETWORK ASSESSMENT ===" > initial_assessment.txt

echo "Date: $(date)" >> initial_assessment.txt

ss -tuln >> initial_assessment.txt

sudo iptables -L -n -v >> initial_assessment.txt

sudo netstat -tulpn >> initial_assessment.txt
```

---

# 🔎 Task 2: Incident Detection & Analysis

---

## 🚦 Subtask 2.1 Generate Suspicious Activity

### Create Traffic Generator

```bash
cat > generate_suspicious_traffic.sh << 'EOF'
#!/bin/bash

nmap -sS localhost > /dev/null 2>&1 &

for i in {1..5}; do
    curl -s http://localhost:8080 > /dev/null &
    sleep 1
done

nc -l -p 9999 > /dev/null 2>&1 &
EOF
```

Make executable:

```bash
chmod +x generate_suspicious_traffic.sh
```

Run simulation:

```bash
./generate_suspicious_traffic.sh
```

---

## 🕵️ Subtask 2.2 Detect Suspicious Activity

### Analyze Connections

```bash
ss -tuln | grep -E "(8080|9999)"
```

### Analyze Processes

```bash
ps aux | grep -E "(python3|nc)"
```

### Capture Traffic

```bash
sudo tcpdump -i lo -c 20 -w suspicious_traffic.pcap port 8080
```

Generate traffic:

```bash
curl http://localhost:8080
```

---

# 🔒 Task 3: Initial Containment

---

## 🛡️ Subtask 3.1 Firewall-Based Containment

### Create Containment Script

```bash
cat > containment_actions.sh << 'EOF'
#!/bin/bash

sudo iptables-save > iptables_backup.txt

sudo iptables -A INPUT -p tcp --dport 8080 -j DROP
sudo iptables -A OUTPUT -p tcp --dport 8080 -j DROP

sudo iptables -A INPUT -p tcp --dport 9999 -j DROP
sudo iptables -A OUTPUT -p tcp --dport 9999 -j DROP

sudo iptables -A INPUT -s 192.168.100.0/24 -j DROP
sudo iptables -A OUTPUT -d 192.168.100.0/24 -j DROP

sudo iptables -A INPUT -j LOG --log-prefix "INCIDENT_BLOCKED: "
sudo iptables -A OUTPUT -j LOG --log-prefix "INCIDENT_BLOCKED: "
EOF
```

Make executable:

```bash
chmod +x containment_actions.sh
```

Execute:

```bash
./containment_actions.sh
```

---

## ✅ Subtask 3.2 Verify Containment

### Test Blocked Port

```bash
timeout 5 curl http://localhost:8080
```

### Verify Firewall Rules

```bash
sudo iptables -L -n -v
```

### Check Suspicious Processes

```bash
ps aux | grep -E "(python3|nc)"
```

---

# 🌐 Task 4: Network Segmentation

---

## 🏗️ Subtask 4.1 Create Security Zones

### Create Segmentation Script

```bash
cat > network_segmentation.sh << 'EOF'
#!/bin/bash

sudo iptables -N QUARANTINE_ZONE

sudo iptables -A QUARANTINE_ZONE -p tcp --dport 22 -j ACCEPT
sudo iptables -A QUARANTINE_ZONE -p tcp --dport 53 -j ACCEPT
sudo iptables -A QUARANTINE_ZONE -p udp --dport 53 -j ACCEPT
sudo iptables -A QUARANTINE_ZONE -j DROP

sudo iptables -N SECURE_ZONE

sudo iptables -A SECURE_ZONE -p tcp --dport 80 -j ACCEPT
sudo iptables -A SECURE_ZONE -p tcp --dport 443 -j ACCEPT
sudo iptables -A SECURE_ZONE -p tcp --dport 22 -j ACCEPT
sudo iptables -A SECURE_ZONE -p tcp --dport 53 -j ACCEPT
sudo iptables -A SECURE_ZONE -p udp --dport 53 -j ACCEPT
sudo iptables -A SECURE_ZONE -j DROP

sudo iptables -A INPUT -s 127.0.0.1 -j SECURE_ZONE
EOF
```

Run:

```bash
chmod +x network_segmentation.sh

./network_segmentation.sh
```

---

## 📑 Subtask 4.2 Segmentation Documentation

Document:

### QUARANTINE_ZONE

| Allowed | Ports |
| ------- | ----- |
| SSH     | 22    |
| DNS     | 53    |

Everything else blocked.

### SECURE_ZONE

| Allowed | Ports |
| ------- | ----- |
| HTTP    | 80    |
| HTTPS   | 443   |
| SSH     | 22    |
| DNS     | 53    |

Everything else blocked.

---

# 🧾 Task 5: Incident Response Reporting

---

## 🔍 Subtask 5.1 Evidence Collection

### Create Evidence Directory

```bash
mkdir -p incident_evidence
```

### Collect Evidence

```bash
cp suspicious_traffic.pcap incident_evidence/

cp initial_assessment.txt incident_evidence/

cp incident_detection.txt incident_evidence/

cp containment_verification.txt incident_evidence/

cp segmentation_config.txt incident_evidence/
```

### Capture System State

```bash
ps aux > incident_evidence/processes.txt

ss -tuln > incident_evidence/network_connections.txt

sudo iptables -L -n -v > incident_evidence/firewall_rules.txt
```

---

## 📄 Subtask 5.2 Professional Incident Report

### Report Sections

#### Executive Summary

* Incident ID
* Severity
* Status

#### Detection

* Discovery Time
* Detection Method
* Impact

#### Containment

* Firewall Actions
* Segmentation Actions
* Evidence Preservation

#### Technical Findings

* Suspicious Ports
* Unauthorized Processes
* Network Traffic Analysis

#### Recommendations

* Enhanced Monitoring
* Security Hardening
* Policy Improvements

---

## 📊 Subtask 5.3 Executive Summary

### Key Findings

✅ Unauthorized Service on Port 8080

✅ Suspicious Listener on Port 9999

✅ Potential Data Exfiltration Attempt

✅ No Confirmed Data Breach

### Actions Taken

✅ Firewall Containment

✅ Network Segmentation

✅ Evidence Collection

✅ Security Documentation

---

# 🧹 Task 6: Cleanup & Restoration

---

## 🛑 Subtask 6.1 Terminate Suspicious Processes

### Stop Python Service

```bash
pkill -f suspicious_server.py
```

### Stop Netcat Listener

```bash
pkill -f "nc.*9999"
```

Verify:

```bash
ps aux | grep -E "(python|nc)"
```

---

## 📋 Subtask 6.2 Final System State

### Document Final Status

```bash
ss -tuln > final_system_state.txt

sudo iptables -L -n -v >> final_system_state.txt

ps aux >> final_system_state.txt
```

---

# ✅ Verification & Testing

---

## Test Blocked Ports

```bash
timeout 3 curl http://localhost:8080

timeout 3 nc -zv localhost 9999
```

---

## Verify Firewall Rules

```bash
sudo iptables -L
```

---

## Verify No Suspicious Processes

```bash
ps aux | grep -E "(suspicious_server|nc.*9999)"
```

---

# 🛠️ Troubleshooting

## Issue 1: Firewall Rules Not Working

```bash
sudo iptables -L -n

sudo iptables-restore < iptables_backup.txt
```

---

## Issue 2: Process Won't Terminate

```bash
sudo pkill -9 -f suspicious_server.py

sudo pkill -9 -f "nc.*9999"
```

---

## Issue 3: Connectivity Problems

Remove blocking rules:

```bash
sudo iptables -D INPUT -p tcp --dport 8080 -j DROP

sudo iptables -D OUTPUT -p tcp --dport 8080 -j DROP
```

Test:

```bash
ping -c 3 localhost
```

---

# 🎓 Conclusion

Congratulations! 🎉

You successfully completed a full Incident Response Simulation.

---

# 🏆 Key Achievements

### 🔎 Incident Detection

* Network Monitoring
* Suspicious Activity Identification
* Traffic Analysis

### 🚨 Containment

* Firewall Rules
* Port Blocking
* Threat Isolation

### 🌐 Network Segmentation

* Quarantine Zone
* Secure Zone
* Access Control

### 📂 Evidence Collection

* Traffic Captures
* System Snapshots
* Firewall Logs

### 📄 Incident Documentation

* Executive Summary
* Technical Findings
* Recommendations

---

# 🌍 Real-World Relevance

These are the same techniques used by:

* SOC Analysts
* Incident Responders
* Threat Hunters
* Security Engineers
* Blue Team Professionals

---

# 🚀 Next Learning Path

* Digital Forensics
* Threat Hunting
* Malware Analysis
* SIEM Platforms
* Security Operations Center (SOC)
* DFIR (Digital Forensics & Incident Response)
* Advanced Network Security

---

<div align="center">

# 🎉 Congratulations!

## 🚨 Incident Response Simulation Lab Completed

### Ready for SOC • Blue Team • DFIR • Incident Response

⭐ Detect • Contain • Investigate • Recover ⭐

</div>
