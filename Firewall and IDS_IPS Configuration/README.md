# 🔥 Firewall and IDS/IPS Configuration Lab

<div align="center">

![Linux](https://img.shields.io/badge/Linux-Ubuntu_20.04+-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Firewall](https://img.shields.io/badge/Firewall-UFW-red?style=for-the-badge&logo=linux)
![Fail2Ban](https://img.shields.io/badge/IDS%2FIPS-Fail2Ban-blue?style=for-the-badge)
![Security](https://img.shields.io/badge/Cyber-Security-green?style=for-the-badge)
![Bash](https://img.shields.io/badge/Bash-Scripting-black?style=for-the-badge&logo=gnubash)
![Monitoring](https://img.shields.io/badge/Log-Monitoring-purple?style=for-the-badge)

</div>

---

# 🛡️ Overview

This lab introduces two essential Linux security technologies:

- 🔥 **UFW (Uncomplicated Firewall)** for network traffic filtering
- 🚨 **Fail2Ban** for intrusion detection and automated attack prevention

By completing this lab, you'll build a basic security architecture capable of defending against brute-force attacks while controlling network access.

---

# 🎯 Learning Objectives

By the end of this lab, you will be able to:

✅ Understand Firewall and IDS/IPS fundamentals

✅ Install and configure Fail2Ban

✅ Configure UFW firewall policies

✅ Monitor authentication and firewall logs

✅ Detect and prevent brute-force attacks

✅ Test and validate security controls

✅ Apply Linux security hardening best practices

---

# 📚 Prerequisites

Before starting this lab, ensure you have:

- 🐧 Basic Linux command-line skills
- ✏️ Familiarity with nano or vim
- 🌐 Understanding of IP addresses and ports
- 🔐 Knowledge of SSH
- 📋 Basic understanding of Linux log files

---

# 🖥️ Lab Environment

The lab environment includes:

- Ubuntu 20.04 LTS or newer
- Root/Sudo Access
- Internet Connectivity
- Networking Tools
- Security Utilities

---

# 🚀 Task 1: Install and Configure Fail2Ban

---

## 📖 Subtask 1.1: Understanding Fail2Ban

### Key Concepts

| Concept | Description |
|----------|-------------|
| 🔒 Jail | Service monitored by Fail2Ban |
| 🔍 Filter | Detects malicious patterns |
| ⚡ Action | Response when attack is detected |
| ⏳ Ban Time | Duration of IP block |

Fail2Ban protects systems against brute-force attacks by monitoring logs and automatically banning suspicious IP addresses.

---

## 📦 Subtask 1.2: Install Fail2Ban

### Update System

```bash
sudo apt update
```

### Install Fail2Ban

```bash
sudo apt install fail2ban -y
```

### Verify Installation

```bash
sudo systemctl status fail2ban
```

Expected Output:

```text
Active: active (running)
```

---

## ⚙️ Subtask 1.3: Configure SSH Protection

### Create Local Configuration

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

### Edit Configuration

```bash
sudo nano /etc/fail2ban/jail.local
```

### Modify Default Settings

```ini
[DEFAULT]

bantime = 600
findtime = 600
maxretry = 3

ignoreip = 127.0.0.1/8 ::1 192.168.1.0/24
```

### Configure SSH Jail

```ini
[sshd]

enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 600
```

---

## ▶️ Subtask 1.4: Enable Fail2Ban

Restart Service

```bash
sudo systemctl restart fail2ban
```

Enable at Boot

```bash
sudo systemctl enable fail2ban
```

Check Status

```bash
sudo fail2ban-client status
```

Check SSH Jail

```bash
sudo fail2ban-client status sshd
```

---

## 🧪 Subtask 1.5: Test Fail2Ban

Create Test Script

```bash
nano test_fail2ban.sh
```

### Script

```bash
#!/bin/bash

echo "Testing Fail2Ban"

sudo fail2ban-client status sshd

logger -p auth.info "sshd[12345]: Failed password for testuser from 192.168.100.100 port 22 ssh2"
logger -p auth.info "sshd[12346]: Failed password for testuser from 192.168.100.100 port 22 ssh2"
logger -p auth.info "sshd[12347]: Failed password for testuser from 192.168.100.100 port 22 ssh2"
logger -p auth.info "sshd[12348]: Failed password for testuser from 192.168.100.100 port 22 ssh2"

sleep 5

sudo fail2ban-client status sshd
```

### Execute

```bash
chmod +x test_fail2ban.sh
./test_fail2ban.sh
```

---

# 🔥 Task 2: Configure UFW Firewall

---

## 📖 Subtask 2.1: Understanding UFW

UFW simplifies firewall management by providing a user-friendly interface for configuring Linux firewall rules.

### Core Concepts

- 🚫 Default Policies
- ✅ Allow Rules
- ❌ Deny Rules
- 🔢 Port Rules
- 📦 Application Profiles

---

## ⚡ Subtask 2.2: Enable UFW

Check Status

```bash
sudo ufw status
```

Enable Firewall

```bash
sudo ufw enable
```

---

## 🔐 Subtask 2.3: Configure Default Policies

Deny Incoming

```bash
sudo ufw default deny incoming
```

Allow Outgoing

```bash
sudo ufw default allow outgoing
```

Verify

```bash
sudo ufw status verbose
```

---

## 🌐 Subtask 2.4: Allow Essential Services

### SSH

```bash
sudo ufw allow ssh
```

or

```bash
sudo ufw allow 22/tcp
```

### HTTP

```bash
sudo ufw allow http
```

or

```bash
sudo ufw allow 80/tcp
```

### HTTPS

```bash
sudo ufw allow https
```

or

```bash
sudo ufw allow 443/tcp
```

---

## 🎯 Subtask 2.5: Advanced Rules

Allow Specific IP

```bash
sudo ufw allow from 192.168.1.100
```

Allow MySQL Access

```bash
sudo ufw allow from 192.168.1.100 to any port 3306
```

Allow Port Range

```bash
sudo ufw allow 8000:8010/tcp
```

Block IP

```bash
sudo ufw deny from 203.0.113.100
```

---

## 📋 Subtask 2.6: Manage Rules

View Rules

```bash
sudo ufw status numbered
```

Delete Rule

```bash
sudo ufw delete X
```

Reset Firewall

```bash
sudo ufw --force reset
```

---

## 🧪 Subtask 2.7: Test Firewall

Create Script

```bash
nano test_firewall.sh
```

### Script

```bash
#!/bin/bash

echo "=== Firewall Status ==="

sudo ufw status numbered

echo ""
echo "Testing HTTP"

curl -I --connect-timeout 5 http://www.google.com | head -1

echo ""
echo "Testing HTTPS"

curl -I --connect-timeout 5 https://www.google.com | head -1

echo ""
echo "Network Connections"

netstat -tuln | head -10

echo ""
echo "Application Profiles"

sudo ufw app list
```

### Run

```bash
chmod +x test_firewall.sh
./test_firewall.sh
```

---

## 🚀 Subtask 2.8: Custom Application Profile

Create Profile

```bash
sudo nano /etc/ufw/applications.d/myapp
```

### Configuration

```ini
[MyWebApp]
title=My Custom Web Application
description=Custom web application
ports=8080/tcp
```

Update Profile

```bash
sudo ufw app update MyWebApp
```

Allow Application

```bash
sudo ufw allow MyWebApp
```

---

# 📊 Task 3: Security Monitoring

---

## 👀 Subtask 3.1: Monitoring Dashboard

Create Script

```bash
nano security_monitor.sh
```

### Script

```bash
#!/bin/bash

echo "=== Security Monitoring Dashboard ==="

date

echo ""
echo "Fail2Ban Status"
sudo fail2ban-client status

echo ""
echo "Banned IPs"
sudo fail2ban-client status sshd

echo ""
echo "Recent Authentication Failures"
sudo tail -20 /var/log/auth.log | grep "Failed password"

echo ""
echo "Firewall Status"
sudo ufw status numbered

echo ""
echo "Recent Firewall Events"
sudo tail -20 /var/log/ufw.log

echo ""
echo "Memory Usage"
free -h

echo ""
echo "Disk Usage"
df -h /

echo ""
echo "Listening Services"
netstat -tuln | grep LISTEN | head -10
```

### Execute

```bash
chmod +x security_monitor.sh
./security_monitor.sh
```

---

## 🔍 Subtask 3.2: Automated Security Check

Create Script

```bash
nano security_check.sh
```

### Script

```bash
#!/bin/bash

echo "=== Comprehensive Security Check ==="

if systemctl is-active --quiet fail2ban
then
    echo "✓ Fail2Ban Running"
else
    echo "✗ Fail2Ban Stopped"
fi

if sudo ufw status | grep -q active
then
    echo "✓ UFW Active"
else
    echo "✗ UFW Inactive"
fi

echo ""
echo "Open Ports"

netstat -tuln | grep LISTEN

echo ""
echo "Available Updates"

apt list --upgradable
```

### Execute

```bash
chmod +x security_check.sh
./security_check.sh
```

---

# 🛠️ Troubleshooting

---

## 🚨 Fail2Ban Not Starting

```bash
sudo fail2ban-client -t
```

```bash
sudo journalctl -u fail2ban -f
```

---

## 🚨 UFW Blocking Traffic

Disable Firewall

```bash
sudo ufw disable
```

Reconfigure and Enable Again

```bash
sudo ufw enable
```

---

## 🚨 Log Files Missing

```bash
sudo ls -la /var/log/auth.log
```

```bash
sudo ls -la /var/log/ufw.log
```

---

## 🚨 Connectivity Testing

Check SSH

```bash
nc -zv localhost 22
```

Check HTTP

```bash
nc -zv localhost 80
```

View Listening Services

```bash
sudo ss -tlnp
```

---

# 📋 Best Practices

✅ Monitor logs daily

✅ Review firewall rules regularly

✅ Backup security configurations

✅ Test firewall changes before deployment

✅ Document every security rule

✅ Monitor system performance

---

# 🧪 Final Verification

Create Verification Script

```bash
nano final_verification.sh
```

### Script

```bash
#!/bin/bash

echo "=== Final Lab Verification ==="

systemctl is-active --quiet fail2ban \
&& echo "✓ Fail2Ban Running" \
|| echo "✗ Fail2Ban Not Running"

sudo ufw status | grep -q active \
&& echo "✓ UFW Active" \
|| echo "✗ UFW Inactive"

sudo ufw status | grep -q "22/tcp" \
&& echo "✓ SSH Rule Configured" \
|| echo "✗ SSH Rule Missing"

[ -f "/etc/fail2ban/jail.local" ] \
&& echo "✓ Fail2Ban Config Exists" \
|| echo "✗ Configuration Missing"

[ -r "/var/log/auth.log" ] \
&& echo "✓ Log Files Accessible" \
|| echo "✗ Log Files Unavailable"
```

### Run Verification

```bash
chmod +x final_verification.sh
./final_verification.sh
```

---

# 🎓 Conclusion

In this lab you successfully:

✅ Installed and configured Fail2Ban

✅ Protected SSH against brute-force attacks

✅ Implemented UFW firewall security policies

✅ Created monitoring and auditing scripts

✅ Performed security validation and testing

✅ Applied Linux security hardening practices

---

# 🚀 Real-World Applications

These skills are used in:

🏢 Enterprise Infrastructure

☁️ Cloud Security

🔐 SOC Operations

🛡️ Server Hardening

📡 Network Defense

🎯 Digital Defense Core Certification

---

# 🏆 Lab Completed

You now have a secure Linux host protected by:

🔥 UFW Firewall

🚨 Fail2Ban IDS/IPS

📊 Security Monitoring

🔍 Log Analysis

🛡️ Automated Security Checks

**Congratulations! Your Firewall & IDS/IPS Configuration Lab is successfully completed.**
