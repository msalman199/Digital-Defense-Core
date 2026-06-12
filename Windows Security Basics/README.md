# 🪟 Windows Security Basics 

![Windows](https://img.shields.io/badge/Windows-Security-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Samba](https://img.shields.io/badge/Samba-Active%20Directory-red?style=for-the-badge&logo=samba&logoColor=white)
![iptables](https://img.shields.io/badge/iptables-Firewall-orange?style=for-the-badge&logo=linux&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![LDAP](https://img.shields.io/badge/OpenLDAP-Directory-blue?style=for-the-badge&logo=openldap&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

- 🏛️ Understand fundamental **Windows security concepts** and hardening techniques
- 🗂️ Configure and manage **Active Directory security policies** using open-source tools
- 🔥 Implement and test **Windows Firewall rules** through simulation
- 📋 Apply **Group Policy concepts** for system hardening
- 🐧 Use **Linux-based tools** to analyze and simulate Windows security configurations
- ✅ Demonstrate knowledge of **Windows security best practices**

---

## ✅ Prerequisites

| Requirement | Description |
|---|---|
| 💻 OS Concepts | Basic understanding of operating system concepts |
| 🖥️ CLI | Familiarity with command-line interfaces |
| 🌐 Networking | Knowledge of IP addresses, ports, and protocols |
| 👤 User Accounts | Understanding of user accounts and permissions |
| 🪟 Windows | Basic knowledge of Windows operating system structure |

---

## 🧪 Lab Environment

> 💡 **Al Nafi** provides ready-to-use Linux-based cloud machines for this lab.  
> Click **Start Lab** to access your pre-configured environment.  
> No need to build your own VM or install additional software.

**🛠️ Your cloud machine comes pre-installed with:**

| Tool | Purpose |
|---|---|
| 🗂️ Samba | Active Directory simulation |
| 🔥 iptables | Firewall rule simulation |
| 📖 OpenLDAP tools | Directory queries |
| ✏️ Text editors | Configuration utilities |

---

# 📋 Task 1 — Secure Active Directory (AD) and Configure Group Policies (GPOs)

![Samba](https://img.shields.io/badge/Samba-Domain%20Controller-red?style=flat-square)
![AD](https://img.shields.io/badge/Active%20Directory-Simulation-0078D6?style=flat-square&logo=windows&logoColor=white)

---

## 🏗️ Subtask 1.1 — Set Up Simulated Active Directory Environment

### ⚙️ Step 1 — Install and Configure Samba

🔄 **Update the system:**

```bash
sudo apt update
```

📦 **Install Samba and related tools:**

```bash
sudo apt install -y samba samba-common-bin smbclient winbind
```

💾 **Create a backup of the original configuration:**

```bash
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup
```

---

### 🖥️ Step 2 — Configure Basic Domain Controller Simulation

✏️ **Create a new Samba configuration file:**

```bash
sudo nano /etc/samba/smb.conf
```

📄 **Add the following configuration:**

```ini
[global]
    workgroup = LABDOMAIN
    realm = LABDOMAIN.LOCAL
    netbios name = LABDC01
    server role = active directory domain controller
    dns forwarder = 8.8.8.8
    idmap_ldb:use rfc2307 = yes
    log level = 1
    log file = /var/log/samba/samba.log
    max log size = 50

[netlogon]
    path = /var/lib/samba/sysvol/labdomain.local/scripts
    read only = No

[sysvol]
    path = /var/lib/samba/sysvol
    read only = No
```

---

### 🌐 Step 3 — Initialize the Domain

🗑️ **Remove existing Samba database and provision the domain:**

```bash
sudo rm -rf /var/lib/samba/*
sudo rm -rf /etc/samba/smb.conf

sudo samba-tool domain provision --use-rfc2307 --interactive
```

📝 **When prompted, use these values:**

| Field | Value |
|---|---|
| 🌐 Realm | `LABDOMAIN.LOCAL` |
| 🏢 Domain | `LABDOMAIN` |
| 🖥️ Server Role | `dc` |
| 🔍 DNS Backend | `SAMBA_INTERNAL` |
| 🔒 Admin Password | `SecurePass123!` |

---

## 👥 Subtask 1.2 — Create Users and Organizational Units

### 🗂️ Step 1 — Create Organizational Units

```bash
# Create IT Department OU
sudo samba-tool ou create "OU=IT,DC=labdomain,DC=local"

# Create HR Department OU
sudo samba-tool ou create "OU=HR,DC=labdomain,DC=local"

# Create Security Groups OU
sudo samba-tool ou create "OU=SecurityGroups,DC=labdomain,DC=local"
```

---

### 🔐 Step 2 — Create Security Groups

```bash
# Create IT Administrators group
sudo samba-tool group add "IT_Administrators" \
  --groupou="OU=SecurityGroups,DC=labdomain,DC=local"

# Create HR Users group
sudo samba-tool group add "HR_Users" \
  --groupou="OU=SecurityGroups,DC=labdomain,DC=local"

# Create Restricted Users group
sudo samba-tool group add "Restricted_Users" \
  --groupou="OU=SecurityGroups,DC=labdomain,DC=local"
```

---

### 👤 Step 3 — Create User Accounts

```bash
# Create IT Administrator user
sudo samba-tool user create itadmin SecurePass123! \
  --userou="OU=IT,DC=labdomain,DC=local"

# Create HR user
sudo samba-tool user create hruser SecurePass123! \
  --userou="OU=HR,DC=labdomain,DC=local"

# Create restricted user
sudo samba-tool user create restricteduser SecurePass123! \
  --userou="OU=HR,DC=labdomain,DC=local"
```

---

### ➕ Step 4 — Add Users to Groups

```bash
# Add itadmin to IT_Administrators group
sudo samba-tool group addmembers "IT_Administrators" itadmin

# Add hruser to HR_Users group
sudo samba-tool group addmembers "HR_Users" hruser

# Add restricteduser to Restricted_Users group
sudo samba-tool group addmembers "Restricted_Users" restricteduser
```

---

## 📋 Subtask 1.3 — Configure Group Policy Objects (GPO) Simulation

### 📁 Step 1 — Create GPO Directory Structure

```bash
sudo mkdir -p /var/lib/samba/sysvol/labdomain.local/Policies
sudo mkdir -p /var/lib/samba/sysvol/labdomain.local/Policies/IT_Security_Policy
sudo mkdir -p /var/lib/samba/sysvol/labdomain.local/Policies/HR_Security_Policy
sudo mkdir -p /var/lib/samba/sysvol/labdomain.local/Policies/Default_Security_Policy
```

---

### 🔑 Step 2 — Create Password Policy Configuration

✏️ **Create password policy config:**

```bash
sudo nano /var/lib/samba/sysvol/labdomain.local/Policies/password_policy.conf
```

📄 **Add the following content:**

```ini
# Password Policy Configuration
[PasswordPolicy]
MinimumPasswordLength=12
PasswordComplexity=Enabled
MaximumPasswordAge=90
MinimumPasswordAge=1
PasswordHistorySize=12
AccountLockoutThreshold=5
AccountLockoutDuration=30
ResetAccountLockoutCounter=30

[IT_Administrators]
MinimumPasswordLength=16
MaximumPasswordAge=60
AccountLockoutThreshold=3

[HR_Users]
MinimumPasswordLength=10
MaximumPasswordAge=120
AccountLockoutThreshold=5

[Restricted_Users]
MinimumPasswordLength=8
MaximumPasswordAge=180
AccountLockoutThreshold=10
```

---

### ▶️ Step 3 — Apply Password Policies

✏️ **Create the apply script:**

```bash
sudo nano /usr/local/bin/apply_password_policies.sh
```

🐚 **Add the following script:**

```bash
#!/bin/bash

echo "Applying password policies..."

sudo samba-tool domain passwordsettings set --complexity=on
sudo samba-tool domain passwordsettings set --history-length=12
sudo samba-tool domain passwordsettings set --min-pwd-length=12
sudo samba-tool domain passwordsettings set --min-pwd-age=1
sudo samba-tool domain passwordsettings set --max-pwd-age=90
sudo samba-tool domain passwordsettings set --account-lockout-threshold=5
sudo samba-tool domain passwordsettings set --account-lockout-duration=30

echo "Password policies applied successfully!"
echo "Current password policy settings:"
sudo samba-tool domain passwordsettings show
```

🔐 **Make executable and run:**

```bash
sudo chmod +x /usr/local/bin/apply_password_policies.sh
sudo /usr/local/bin/apply_password_policies.sh
```

---

## 🛡️ Subtask 1.4 — Implement Security Hardening Policies

### 📊 Step 1 — Create Security Audit Configuration

✏️ **Create audit policy configuration:**

```bash
sudo nano /var/lib/samba/sysvol/labdomain.local/Policies/audit_policy.conf
```

📄 **Add the following content:**

```ini
# Security Audit Policy Configuration
[AuditPolicy]
AuditAccountLogon=Success,Failure
AuditAccountManagement=Success,Failure
AuditDirectoryServiceAccess=Success,Failure
AuditLogonEvents=Success,Failure
AuditObjectAccess=Success,Failure
AuditPolicyChange=Success,Failure
AuditPrivilegeUse=Success,Failure
AuditProcessTracking=Success
AuditSystemEvents=Success,Failure

[LoggingSettings]
MaxLogSize=100MB
LogRetention=90days
LogLocation=/var/log/samba/security.log
```

---

### 👤 Step 2 — Create User Rights Assignment Script

✏️ **Create the script:**

```bash
sudo nano /usr/local/bin/configure_user_rights.sh
```

🐚 **Add the following script:**

```bash
#!/bin/bash

echo "Configuring user rights assignments..."

cat > /tmp/user_rights.conf << EOF
# User Rights Assignment Configuration

# IT Administrators Rights
IT_Administrators:
  - LogonAsService
  - BackupFiles
  - RestoreFiles
  - ManageAuditing
  - TakeOwnership

# HR Users Rights  
HR_Users:
  - LogonLocally
  - ChangeSystemTime (Denied)
  - ShutdownSystem (Denied)

# Restricted Users Rights
Restricted_Users:
  - LogonLocally
  - AccessNetworkResources (Limited)
  - InstallSoftware (Denied)
  - ModifySystemSettings (Denied)
EOF

echo "User rights configuration created at /tmp/user_rights.conf"

echo "$(date): User rights configured for IT_Administrators group" >> /var/log/samba/security.log
echo "$(date): User rights configured for HR_Users group" >> /var/log/samba/security.log
echo "$(date): User rights configured for Restricted_Users group" >> /var/log/samba/security.log

echo "User rights assignment completed!"
```

🔐 **Make executable and run:**

```bash
sudo chmod +x /usr/local/bin/configure_user_rights.sh
sudo /usr/local/bin/configure_user_rights.sh
```

---

# 📋 Task 2 — Implement Windows Firewall Rules

![iptables](https://img.shields.io/badge/iptables-Firewall%20Simulation-orange?style=flat-square)
![Network](https://img.shields.io/badge/Network-Security%20Rules-blue?style=flat-square)
![Logging](https://img.shields.io/badge/Logging-Monitoring-green?style=flat-square)

---

## 🔥 Subtask 2.1 — Set Up Firewall Rule Simulation

### 📦 Step 1 — Install and Configure iptables

```bash
sudo apt install -y iptables iptables-persistent

# Clear existing rules
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
```

---

### 🛡️ Step 2 — Create Basic Firewall Policy

```bash
# Set default policies (simulate Windows Firewall default behavior)
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

---

## 🏢 Subtask 2.2 — Configure Domain-Specific Firewall Rules

### 🔌 Step 1 — Allow Active Directory Traffic

```bash
# Allow DNS (port 53) - Required for AD
sudo iptables -A INPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 53 -j ACCEPT

# Allow Kerberos (port 88) - Required for AD authentication
sudo iptables -A INPUT -p tcp --dport 88 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 88 -j ACCEPT

# Allow LDAP (port 389) - Required for AD queries
sudo iptables -A INPUT -p tcp --dport 389 -j ACCEPT

# Allow LDAPS (port 636) - Secure LDAP
sudo iptables -A INPUT -p tcp --dport 636 -j ACCEPT

# Allow SMB/CIFS (ports 139, 445) - Required for file sharing
sudo iptables -A INPUT -p tcp --dport 139 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 445 -j ACCEPT
```

---

### 🌐 Step 2 — Create Application-Specific Rules

```bash
# Allow SSH (port 22) for remote administration
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP (port 80) for web services
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow HTTPS (port 443) for secure web services
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Block common attack ports
sudo iptables -A INPUT -p tcp --dport 23 -j DROP   # Telnet
sudo iptables -A INPUT -p tcp --dport 135 -j DROP  # RPC
sudo iptables -A INPUT -p tcp --dport 1433 -j DROP # SQL Server (if not needed)
```

> **Allowed & Blocked Ports Summary:**

| Port | Protocol | Action | Reason |
|---|---|---|---|
| 22 | TCP | ✅ ALLOW | SSH remote admin |
| 53 | TCP/UDP | ✅ ALLOW | DNS for AD |
| 80 | TCP | ✅ ALLOW | HTTP web services |
| 88 | TCP/UDP | ✅ ALLOW | Kerberos auth |
| 389 | TCP | ✅ ALLOW | LDAP queries |
| 443 | TCP | ✅ ALLOW | HTTPS web services |
| 636 | TCP | ✅ ALLOW | Secure LDAP |
| 23 | TCP | 🚫 BLOCK | Telnet (insecure) |
| 135 | TCP | 🚫 BLOCK | RPC (attack vector) |
| 1433 | TCP | 🚫 BLOCK | SQL Server |

---

## ⚙️ Subtask 2.3 — Implement Advanced Firewall Rules

### ⏰ Step 1 — Create Time-Based Access Rules

✏️ **Create the script:**

```bash
sudo nano /usr/local/bin/time_based_firewall.sh
```

🐚 **Add the following script:**

```bash
#!/bin/bash

# Time-based firewall rules (simulate Windows Firewall time restrictions)

CURRENT_HOUR=$(date +%H)
CURRENT_DAY=$(date +%u)  # 1=Monday, 7=Sunday

echo "Current time: $(date)"
echo "Hour: $CURRENT_HOUR, Day: $CURRENT_DAY"

# Remove existing time-based rules
sudo iptables -D INPUT -p tcp --dport 3389 -j ACCEPT 2>/dev/null || true
sudo iptables -D INPUT -p tcp --dport 3389 -j DROP 2>/dev/null || true

# RDP access (port 3389) - only during business hours on weekdays
if [ $CURRENT_DAY -ge 1 ] && [ $CURRENT_DAY -le 5 ]; then
    if [ $CURRENT_HOUR -ge 8 ] && [ $CURRENT_HOUR -lt 18 ]; then
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
```

🔐 **Make executable and run:**

```bash
sudo chmod +x /usr/local/bin/time_based_firewall.sh
sudo /usr/local/bin/time_based_firewall.sh
```

---

### 🌍 Step 2 — Create IP-Based Access Control

✏️ **Create the script:**

```bash
sudo nano /usr/local/bin/ip_based_firewall.sh
```

🐚 **Add the following script:**

```bash
#!/bin/bash

# IP-based access control (simulate Windows Firewall IP restrictions)

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

# Block known malicious IP ranges
sudo iptables -A INPUT -s 10.0.0.0/8 -j DROP
sudo iptables -A INPUT -s 172.16.0.0/12 -j DROP

echo "IP-based access control configured!"
```

🔐 **Make executable and run:**

```bash
sudo chmod +x /usr/local/bin/ip_based_firewall.sh
sudo /usr/local/bin/ip_based_firewall.sh
```

---

## 📊 Subtask 2.4 — Configure Logging and Monitoring

### 📋 Step 1 — Enable Firewall Logging

```bash
# Create logging rules for dropped packets
sudo iptables -A INPUT -j LOG --log-prefix "FIREWALL-DROPPED: " --log-level 4
sudo iptables -A INPUT -j DROP

# Create logging rules for accepted connections
sudo iptables -I INPUT 1 -j LOG --log-prefix "FIREWALL-ACCEPTED: " --log-level 4
```

---

### 📈 Step 2 — Create Firewall Monitoring Script

✏️ **Create the script:**

```bash
sudo nano /usr/local/bin/firewall_monitor.sh
```

🐚 **Add the following script:**

```bash
#!/bin/bash

LOG_FILE="/var/log/firewall_monitor.log"
ALERT_THRESHOLD=10

echo "=== Firewall Monitor Report - $(date) ===" >> $LOG_FILE

DROPPED_COUNT=$(grep "FIREWALL-DROPPED" /var/log/syslog | grep "$(date '+%b %d %H')" | wc -l)
echo "Dropped packets in last hour: $DROPPED_COUNT" >> $LOG_FILE

if [ $DROPPED_COUNT -gt $ALERT_THRESHOLD ]; then
    echo "ALERT: High number of dropped packets detected!" >> $LOG_FILE
    echo "Potential security incident - investigate immediately" >> $LOG_FILE
fi

echo "Current firewall rules:" >> $LOG_FILE
sudo iptables -L -n >> $LOG_FILE

echo "Connection statistics:" >> $LOG_FILE
ss -tuln >> $LOG_FILE

echo "=== End Report ===" >> $LOG_FILE
echo "" >> $LOG_FILE

echo "Firewall Monitor Summary:"
echo "- Dropped packets in last hour: $DROPPED_COUNT"
echo "- Log file: $LOG_FILE"
echo "- Current active rules: $(sudo iptables -L | grep -c '^ACCEPT\|^DROP\|^REJECT')"
```

🔐 **Make executable and run:**

```bash
sudo chmod +x /usr/local/bin/firewall_monitor.sh
sudo /usr/local/bin/firewall_monitor.sh
```

---

## 🧪 Subtask 2.5 — Test Firewall Rules

### ✅ Step 1 — Create Firewall Testing Script

✏️ **Create the script:**

```bash
sudo nano /usr/local/bin/test_firewall.sh
```

🐚 **Add the following script:**

```bash
#!/bin/bash

echo "=== Firewall Rule Testing ==="

echo "Testing allowed services..."

if nc -z localhost 22 2>/dev/null; then
    echo "✓ SSH (port 22): ACCESSIBLE"
else
    echo "✗ SSH (port 22): BLOCKED"
fi

if nc -z localhost 80 2>/dev/null; then
    echo "✓ HTTP (port 80): ACCESSIBLE"
else
    echo "✗ HTTP (port 80): BLOCKED"
fi

echo ""
echo "Testing blocked services..."

if nc -z localhost 23 2>/dev/null; then
    echo "✗ Telnet (port 23): ACCESSIBLE (SECURITY RISK!)"
else
    echo "✓ Telnet (port 23): BLOCKED"
fi

if nc -z localhost 135 2>/dev/null; then
    echo "✗ RPC (port 135): ACCESSIBLE (SECURITY RISK!)"
else
    echo "✓ RPC (port 135): BLOCKED"
fi

echo ""
echo "=== Firewall Status ==="
sudo iptables -L -n | grep -E "ACCEPT|DROP|REJECT" | head -10

echo ""
echo "=== Recent Firewall Logs ==="
tail -5 /var/log/syslog | grep "FIREWALL" || echo "No recent firewall logs found"
```

🔐 **Make executable and run:**

```bash
sudo chmod +x /usr/local/bin/test_firewall.sh
sudo /usr/local/bin/test_firewall.sh
```

---

### 💾 Step 2 — Save Firewall Configuration

💾 **Save current iptables rules:**

```bash
sudo iptables-save > /etc/iptables/rules.v4
```

✏️ **Create startup service:**

```bash
sudo nano /etc/systemd/system/firewall-rules.service
```

📄 **Add the following service configuration:**

```ini
[Unit]
Description=Load Firewall Rules
After=network.target

[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore /etc/iptables/rules.v4
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

🚀 **Enable the service:**

```bash
sudo systemctl enable firewall-rules.service
sudo systemctl start firewall-rules.service
```

---

# 🔍 Verification and Testing

## 🏛️ Verify Active Directory Configuration

### 🧪 Step 1 — Test Domain Services

```bash
# Check Samba services
sudo systemctl status smbd
sudo systemctl status nmbd

# Test domain functionality
sudo samba-tool domain level show
sudo samba-tool user list
sudo samba-tool group list
```

---

### 🔐 Step 2 — Verify User Authentication

```bash
# Test user accounts
sudo samba-tool user show itadmin
sudo samba-tool user show hruser
sudo samba-tool user show restricteduser

# Check group memberships
sudo samba-tool group listmembers "IT_Administrators"
sudo samba-tool group listmembers "HR_Users"
sudo samba-tool group listmembers "Restricted_Users"
```

---

## 🔥 Verify Firewall Configuration

### 📋 Step 1 — Check Firewall Rules

```bash
# Display all firewall rules
sudo iptables -L -n -v

# Check specific chains
sudo iptables -L INPUT -n -v
sudo iptables -L OUTPUT -n -v
```

---

### 🌐 Step 2 — Test Network Connectivity

```bash
# Test internal connectivity
ping -c 3 127.0.0.1

# Check listening services
sudo netstat -tlnp | grep LISTEN

# Verify firewall logs
sudo tail -20 /var/log/syslog | grep "FIREWALL"
```

---

# 🔧 Troubleshooting Common Issues

<details>
<summary>🔴 Active Directory — Samba services won't start</summary>

Check configuration syntax:

```bash
sudo testparm
```

Check log files:

```bash
sudo tail -20 /var/log/samba/samba.log
```

Restart services:

```bash
sudo systemctl restart smbd nmbd
```

</details>

<details>
<summary>🔴 Active Directory — Users cannot authenticate</summary>

Reset user password:

```bash
sudo samba-tool user setpassword username
```

Check user account status:

```bash
sudo samba-tool user show username
```

</details>

<details>
<summary>🔴 Firewall — Cannot access required services</summary>

Check if the service is running:

```bash
sudo systemctl status service_name
```

Verify firewall rules:

```bash
sudo iptables -L -n | grep port_number
```

Add missing rule:

```bash
sudo iptables -A INPUT -p tcp --dport port_number -j ACCEPT
```

</details>

<details>
<summary>🔴 Firewall — Too many dropped packets</summary>

Check recent logs:

```bash
sudo tail -50 /var/log/syslog | grep "FIREWALL-DROPPED"
```

Analyze traffic patterns:

```bash
sudo iptables -L -n -v | grep DROP
```

</details>

---

# 🏆 Security Best Practices Summary

## 🏛️ Active Directory Security

| Practice | Description |
|---|---|
| 🔑 Strong Password Policies | Complex requirements with regular expiration |
| 🔐 Least Privilege | Grant users only the minimum permissions needed |
| 📊 Regular Auditing | Monitor user activities and access patterns |
| 👥 Group-Based Management | Use security groups for efficient permissions |
| 🚫 Account Lockout | Protect against brute force attacks |

## 🔥 Firewall Security

| Practice | Description |
|---|---|
| 🛡️ Default Deny Policy | Block all traffic by default, allow only necessary |
| 🔁 Regular Rule Review | Periodically audit and update firewall rules |
| 📋 Logging & Monitoring | Enable comprehensive logging for security analysis |
| 🌐 Network Segmentation | Use different rules for different network segments |
| ⏰ Time-Based Access | Implement time restrictions for sensitive services |

---

# ✅ Expected Outcomes

After completing this lab, you should have:

- ✅ **Simulated Active Directory** environment with OUs, groups, and users
- ✅ **Password and lockout policies** applied via Samba tools
- ✅ **Audit policy configuration** for security event tracking
- ✅ **User rights assignments** per group role
- ✅ **iptables firewall** with AD, app, time-based, and IP-based rules
- ✅ **Firewall monitoring script** detecting dropped packet anomalies
- ✅ **Persistent firewall rules** loaded via systemd on boot

---

# 🎓 Conclusion

In this lab, you successfully implemented fundamental **Windows security concepts** using open-source tools on a Linux platform. Here's a summary of what was accomplished:

| Area | Achievement |
|---|---|
| 🏛️ AD Setup | Samba domain, OUs, security groups, and user accounts |
| 🔑 GPO Simulation | Password policies, audit logging, user rights |
| 🔥 Firewall Rules | AD traffic, app rules, time & IP-based access control |
| 📊 Monitoring | Logging, alerting, and firewall testing scripts |
| 🚀 Automation | Persistent rules via systemd service |

---

## 💡 Key Takeaways

| # | Takeaway |
|---|---|
| 🏛️ | **Active Directory** enables centralized identity and access management |
| 📋 | **GPOs** enforce consistent security policies across the organization |
| 🔥 | **Default-deny firewall** policies minimize the attack surface |
| 👥 | **Group-based permissions** simplify and secure access control |
| 📊 | **Auditing and logging** are essential for detecting incidents |
| 🔁 | **Security is an ongoing process** — review and update regularly |

---

## 🚀 Next Steps

![GPO](https://img.shields.io/badge/Next-Advanced%20GPOs-0078D6?style=flat-square&logo=windows&logoColor=white)
![SIEM](https://img.shields.io/badge/Next-SIEM%20Integration-blue?style=flat-square)
![Defender](https://img.shields.io/badge/Next-Windows%20Defender-green?style=flat-square&logo=windows&logoColor=white)
![Compliance](https://img.shields.io/badge/Next-CIS%20Benchmarks-red?style=flat-square)

- 🔵 Explore **advanced Group Policy Object** configurations
- 🟢 Study **Windows Defender** and endpoint protection tools
- 🔵 Investigate **SIEM integration** for centralized log management
- 🔴 Apply **CIS Benchmarks** for comprehensive Windows hardening

---

<div align="center">

![Made with](https://img.shields.io/badge/Made%20with-❤️%20for%20Security-blueviolet?style=for-the-badge)
![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Lab%20Guide-0077B5?style=for-the-badge)

</div>
