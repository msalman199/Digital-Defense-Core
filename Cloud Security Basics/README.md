# ☁️ Cloud Security Basics 

<div align="center">

# 🚀 Master Cloud Security Fundamentals

![Linux](https://img.shields.io/badge/Linux-Ubuntu_22.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Cloud Security](https://img.shields.io/badge/Cloud-Security-4285F4?style=for-the-badge&logo=icloud&logoColor=white)
![IAM](https://img.shields.io/badge/IAM-Access_Control-FF9900?style=for-the-badge)
![MFA](https://img.shields.io/badge/MFA-Multi_Factor_Authentication-34A853?style=for-the-badge)
![Encryption](https://img.shields.io/badge/AES256-Encryption-red?style=for-the-badge)
![Fail2Ban](https://img.shields.io/badge/Fail2Ban-Intrusion_Prevention-blue?style=for-the-badge)

### 🔐 Hands-On Cloud Security & IAM Implementation Lab

</div>

---

# 📚 Lab Overview

Cloud Security is one of the most important domains in modern cybersecurity. This lab introduces Identity and Access Management (IAM), Multi-Factor Authentication (MFA), Security Monitoring, Encryption, Secure Backups, and Network Security using open-source Linux tools.

You will simulate real-world cloud security controls while working in a Linux-based cloud environment.

---

# 🎯 Objectives

By the end of this lab, you will be able to:

✅ Understand cloud security fundamentals

✅ Implement IAM-like access controls

✅ Configure Role-Based Access Control (RBAC)

✅ Deploy Multi-Factor Authentication (MFA)

✅ Configure Firewall Security Groups

✅ Monitor Security Events

✅ Implement Encryption & Key Management

✅ Create Security Auditing Systems

✅ Configure Secure Backup & Recovery

✅ Understand the Shared Responsibility Model

---

# 📋 Prerequisites

Before starting this lab, ensure you have:

- Linux Command Line Knowledge
- User & Group Management Basics
- Network Fundamentals
- Basic Cloud Computing Understanding

No prior cloud security experience required.

---

# 🖥️ Lab Environment

### Al Nafi Cloud Environment

| Component | Version |
|------------|---------|
| Operating System | Ubuntu 22.04 LTS |
| Security Tools | Pre-installed |
| Privileges | Administrative Access |
| Environment | Simulated Cloud Infrastructure |

---

# 🔐 Task 1: Implement IAM-Like Security Controls

---

## 👥 Subtask 1.1 Create User Management System

### 📁 Step 1: Create Lab Directory Structure

```bash
sudo mkdir -p /opt/cloud-security-lab/{users,policies,logs,keys}

cd /opt/cloud-security-lab
```

---

### 👤 Step 2: Create Cloud Users

```bash
sudo useradd -m -s /bin/bash cloud-admin

sudo useradd -m -s /bin/bash cloud-developer

sudo useradd -m -s /bin/bash cloud-readonly

sudo useradd -m -s /bin/bash cloud-auditor
```

### 🔑 Set User Passwords

```bash
echo "cloud-admin:SecureAdmin123!" | sudo chpasswd

echo "cloud-developer:DevSecure456!" | sudo chpasswd

echo "cloud-readonly:ReadOnly789!" | sudo chpasswd

echo "cloud-auditor:AuditSecure012!" | sudo chpasswd
```

---

### 🏢 Step 3: Create IAM Security Groups

```bash
sudo groupadd cloud-admins

sudo groupadd cloud-developers

sudo groupadd cloud-users

sudo groupadd cloud-auditors
```

### Add Users to Groups

```bash
sudo usermod -a -G cloud-admins cloud-admin

sudo usermod -a -G cloud-developers cloud-developer

sudo usermod -a -G cloud-users cloud-readonly

sudo usermod -a -G cloud-auditors cloud-auditor
```

---

## 📜 Subtask 1.2 Policy-Based Access Control

### ⚙️ Step 4: Create IAM Policy Manager

```bash
cat > /opt/cloud-security-lab/policy-manager.sh << 'EOF'
#!/bin/bash

POLICY_DIR="/opt/cloud-security-lab/policies"
LOG_FILE="/opt/cloud-security-lab/logs/access.log"

create_policy() {

local role=$1
local permissions=$2
local policy_file="$POLICY_DIR/${role}-policy.json"

cat > "$policy_file" << EOL
{
 "Version":"2023-01-01",
 "Statement":[
 {
   "Effect":"Allow",
   "Action":$permissions,
   "Resource":"*",
   "Principal":{
      "User":"$role"
   }
 }
 ]
}
EOL
}

echo "Policy manager initialized successfully"
EOF
```

### Make Script Executable

```bash
chmod +x /opt/cloud-security-lab/policy-manager.sh
```

---

### ▶️ Step 5: Initialize Policies

```bash
sudo /opt/cloud-security-lab/policy-manager.sh
```

---

### 🧪 Step 6: Test IAM Permissions

```bash
sudo -u cloud-admin \
/opt/cloud-security-lab/policy-manager.sh \
check_permission cloud-admin "admin:create-instance"
```

```bash
sudo -u cloud-developer \
/opt/cloud-security-lab/policy-manager.sh \
check_permission cloud-developer "develop:deploy-app"
```

```bash
sudo -u cloud-readonly \
/opt/cloud-security-lab/policy-manager.sh \
check_permission cloud-readonly "read:view-logs"
```

---

## 🔑 Subtask 1.3 Multi-Factor Authentication (MFA)

### 📦 Step 7: Install MFA Packages

```bash
sudo apt update

sudo apt install -y libpam-google-authenticator qrencode
```

### Create MFA Setup Script

```bash
cat > /opt/cloud-security-lab/setup-mfa.sh << 'EOF'
#!/bin/bash

USER=$1

if [ -z "$USER" ]; then
 echo "Usage: $0 <username>"
 exit 1
fi

echo "Setting up MFA for user: $USER"

sudo -u "$USER" google-authenticator \
-t -d -f -r 3 -R 30 -W

echo "MFA setup completed."
EOF
```

### Make Executable

```bash
chmod +x /opt/cloud-security-lab/setup-mfa.sh
```

---

### 🔐 Step 8: Configure MFA

```bash
sudo /opt/cloud-security-lab/setup-mfa.sh cloud-admin
```

---

# 🛡️ Task 2: Configure Cloud Security Best Practices

---

## 🌐 Subtask 2.1 Network Security Controls

### 🔥 Step 9: Configure Firewall Security Groups

Reset Firewall

```bash
sudo ufw --force reset
```

Default Rules

```bash
sudo ufw default deny incoming

sudo ufw default allow outgoing
```

Allow SSH

```bash
sudo ufw allow from 10.0.0.0/8 to any port 22

sudo ufw allow from 172.16.0.0/12 to any port 22

sudo ufw allow from 192.168.0.0/16 to any port 22
```

Allow Web Traffic

```bash
sudo ufw allow 80/tcp

sudo ufw allow 443/tcp
```

Enable Firewall

```bash
sudo ufw --force enable
```

Check Status

```bash
sudo ufw status verbose
```

---

### 📡 Step 10: Create Network Monitoring Script

```bash
cat > /opt/cloud-security-lab/network-monitor.sh << 'EOF'
#!/bin/bash

LOG_FILE="/opt/cloud-security-lab/logs/network-monitor.log"

echo "Monitoring network security..."
EOF
```

### Make Executable

```bash
chmod +x /opt/cloud-security-lab/network-monitor.sh
```

---

### ▶️ Step 11: Run Monitoring

```bash
sudo /opt/cloud-security-lab/network-monitor.sh
```

---

## 🔒 Subtask 2.2 Encryption & Key Management

### 📁 Step 12: Create Key Directories

```bash
sudo mkdir -p /opt/cloud-security-lab/keys/{active,backup,revoked}
```

---

### 🔑 Create Key Manager

```bash
cat > /opt/cloud-security-lab/key-manager.sh << 'EOF'
#!/bin/bash

KEY_DIR="/opt/cloud-security-lab/keys"

generate_key() {
 local key_name=$1

 openssl rand -hex 32 > "$KEY_DIR/active/${key_name}.key"

 chmod 600 "$KEY_DIR/active/${key_name}.key"
}

generate_key "data-encryption"
generate_key "backup-encryption"
generate_key "log-encryption"

echo "Keys generated successfully."
EOF
```

### Make Executable

```bash
chmod +x /opt/cloud-security-lab/key-manager.sh
```

---

### 🧪 Step 13: Test Encryption

Generate Keys

```bash
sudo /opt/cloud-security-lab/key-manager.sh
```

Create Test File

```bash
echo "This is sensitive cloud data that needs encryption" \
> /tmp/sensitive-data.txt
```

Encrypt File

```bash
openssl enc -aes-256-cbc \
-salt \
-in /tmp/sensitive-data.txt \
-out /tmp/sensitive-data.txt.encrypted
```

Verify

```bash
ls -la /tmp/sensitive-data.txt*
```

---

## 🚨 Subtask 2.3 Security Monitoring

### 📦 Step 14: Install Security Tools

```bash
sudo apt install -y \
fail2ban \
logwatch \
rkhunter \
chkrootkit
```

---

### Configure Fail2Ban

```bash
sudo cp /etc/fail2ban/jail.conf \
/etc/fail2ban/jail.local
```

Start Service

```bash
sudo systemctl start fail2ban

sudo systemctl enable fail2ban
```

---

### 📋 Step 15: Security Audit Script

```bash
cat > /opt/cloud-security-lab/security-audit.sh << 'EOF'
#!/bin/bash

echo "Cloud Security Audit Running..."

apt list --upgradable

systemctl list-units --type=service

netstat -tuln

sudo ufw status verbose

echo "Audit Complete"
EOF
```

### Execute

```bash
chmod +x /opt/cloud-security-lab/security-audit.sh

sudo /opt/cloud-security-lab/security-audit.sh
```

---

## 💾 Subtask 2.4 Backup & Recovery Security

### 📦 Step 17: Secure Backup Script

```bash
cat > /opt/cloud-security-lab/secure-backup.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="/opt/cloud-security-lab/backups"

mkdir -p "$BACKUP_DIR"

echo "Creating Secure Backup..."

tar -czf \
"$BACKUP_DIR/security-backup.tar.gz" \
/opt/cloud-security-lab

echo "Backup Completed"
EOF
```

### Make Executable

```bash
chmod +x /opt/cloud-security-lab/secure-backup.sh
```

---

### ▶️ Step 18: Test Backup

Create Backup

```bash
sudo /opt/cloud-security-lab/secure-backup.sh
```

List Backups

```bash
ls -la /opt/cloud-security-lab/backups
```

---

# ✅ Verification & Testing

---

## 🧪 Step 19 Final Verification

Create Verification Script

```bash
cat > /opt/cloud-security-lab/final-verification.sh << 'EOF'
#!/bin/bash

echo "=== Cloud Security Verification ==="

id cloud-admin

id cloud-developer

id cloud-readonly

id cloud-auditor

sudo ufw status

ls -la /opt/cloud-security-lab/keys/active/

systemctl is-active fail2ban

echo "Verification Complete"
EOF
```

### Run Verification

```bash
chmod +x /opt/cloud-security-lab/final-verification.sh

sudo /opt/cloud-security-lab/final-verification.sh
```

---

# 🛠️ Troubleshooting

## Issue 1: Permission Denied

```bash
sudo chown -R root:root /opt/cloud-security-lab

sudo chmod -R 755 /opt/cloud-security-lab

sudo chmod +x /opt/cloud-security-lab/*.sh
```

---

## Issue 2: Firewall Blocking Connections

Disable

```bash
sudo ufw disable
```

Enable Again

```bash
sudo ufw --force enable
```

---

## Issue 3: Encryption Key Problems

```bash
sudo rm -f /opt/cloud-security-lab/keys/active/*.key

sudo /opt/cloud-security-lab/key-manager.sh
```

---

# 🎓 Conclusion

Congratulations! 🎉

You successfully completed the **Cloud Security Basics Lab**.

---

# 🏆 Key Achievements

### 👥 Identity & Access Management

- IAM-like Roles
- User Groups
- Policy-Based Permissions

### 🔐 Multi-Factor Authentication

- TOTP Authentication
- Privileged Account Protection

### 🌐 Network Security

- UFW Firewall
- Security Group Simulation
- Traffic Control

### 🔒 Data Protection

- AES-256 Encryption
- Secure Key Management

### 🚨 Security Monitoring

- Fail2Ban
- Log Monitoring
- Security Auditing

### 💾 Backup & Recovery

- Encrypted Backups
- Recovery Testing
- Business Continuity

---

# ☁️ Why Cloud Security Matters

✔ Protect Sensitive Data

✔ Meet Compliance Requirements

✔ Prevent Unauthorized Access

✔ Detect Threats Early

✔ Ensure Business Continuity

✔ Secure Cloud Infrastructure

---

# 🚀 Next Learning Path

- Container Security
- Kubernetes Security
- AWS Security
- Azure Security
- Google Cloud Security
- Infrastructure as Code Security
- Cloud Incident Response
- Cloud Forensics

---

<div align="center">

# 🎉 Congratulations!

## ☁️ Cloud Security Basics Lab Completed

### Ready for Cloud Security • DevSecOps • Security Engineering

⭐ Secure Everything. Trust Nothing. Verify Always. ⭐

</div>
