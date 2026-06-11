# 🛡️ Defense-in-Depth Lab — Full Implementation Guide

![Linux](https://img.shields.io/badge/Linux-Ubuntu-Security-E95420?style=for-the-badge&logo=ubuntu)
![CyberSecurity](https://img.shields.io/badge/CyberSecurity-Defense%20in%20Depth-red?style=for-the-badge)
![RBAC](https://img.shields.io/badge/RBAC-Access%20Control-blue?style=for-the-badge)
![Automation](https://img.shields.io/badge/Security-Automation-green?style=for-the-badge)

---

# 🚀 Introduction to Defense-in-Depth

This lab demonstrates how to implement a **multi-layer security architecture** on Linux using:

- 🔐 Role-Based Access Control (RBAC)
- 🧱 File and directory permissions
- ⚙️ Security automation scripts
- 📊 System auditing
- 🛡️ Policy enforcement tools

---

# 🎯 Objectives

By the end of this lab, you will be able to:

✔ Understand Defense-in-Depth strategy  
✔ Identify multiple security layers in Linux  
✔ Implement RBAC (Role-Based Access Control)  
✔ Create and manage secure user accounts  
✔ Automate security policy enforcement  
✔ Apply layered security in real systems  

---

# 📌 Prerequisites

- Linux command line basics  
- File permissions understanding  
- Text editors (nano/vim)  
- Basic cybersecurity knowledge  

---

# 🖥️ Lab Environment

- Ubuntu Cloud VM (Al Nafi Platform)
- No manual setup required
- Preconfigured Linux environment

---

# 🧱 TASK 1 — Defense-in-Depth Strategy

---

## 📁 Step 1.1: Create Documentation

```bash id="def-doc"
mkdir ~/defense-lab
cd ~/defense-lab
nano defense-concepts.txt
📄 Defense-in-Depth Model
DEFENSE-IN-DEPTH SECURITY MODEL

1️⃣ PHYSICAL SECURITY
- Biometrics
- CCTV monitoring
- Server room access

2️⃣ NETWORK SECURITY
- Firewalls
- IDS/IPS
- VPN access

3️⃣ HOST SECURITY
- OS hardening
- Antivirus
- System monitoring

4️⃣ APPLICATION SECURITY
- Secure coding
- Input validation
- Auth systems

5️⃣ DATA SECURITY
- Encryption
- Access control
- Backup systems

6️⃣ PROCEDURAL SECURITY
- Policies
- Training
- Incident response
🔍 Step 1.2: System Security Review
sudo ufw status
cat /etc/passwd | grep -E "(root|ubuntu)"
ls -la /etc/passwd /etc/shadow /etc/sudoers
systemctl list-units --type=service | grep ssh
👥 TASK 2 — RBAC Implementation
🧩 Step 2.1: Create Security Groups
sudo groupadd security-admins
sudo groupadd security-analysts
sudo groupadd security-users
👤 Step 2.2: Create Users
sudo useradd -m -s /bin/bash -G security-admins sec-admin
sudo useradd -m -s /bin/bash -G security-analysts sec-analyst
sudo useradd -m -s /bin/bash -G security-users sec-user

sudo passwd sec-admin
sudo passwd sec-analyst
sudo passwd sec-user
📂 Step 2.3: Secure Directory Structure
sudo mkdir -p /opt/security/{admin,analyst,shared,logs}

sudo chown root:security-admins /opt/security/admin
sudo chmod 750 /opt/security/admin

sudo chown root:security-analysts /opt/security/analyst
sudo chmod 750 /opt/security/analyst

sudo chown root:security-users /opt/security/shared
sudo chmod 755 /opt/security/shared

sudo chown root:security-admins /opt/security/logs
sudo chmod 740 /opt/security/logs
🧪 Step 2.4: RBAC Testing
sudo su - sec-admin
touch /opt/security/admin/test.txt
exit

sudo su - sec-analyst
ls /opt/security/admin
exit
⚙️ TASK 3 — Security Automation Scripts
👤 Step 3.1: User Creation Script
nano create-security-user.sh
chmod +x create-security-user.sh
📄 Script
#!/bin/bash

USERNAME=$1
ROLE=$2

case $ROLE in
  admin) GROUP="security-admins" ;;
  analyst) GROUP="security-analysts" ;;
  user) GROUP="security-users" ;;
esac

sudo useradd -m -G $GROUP $USERNAME
echo "User $USERNAME created with role $ROLE"
🔍 Step 3.2: Security Audit Script
nano security-audit.sh
chmod +x security-audit.sh
📄 Audit Script
#!/bin/bash

echo "🔍 SECURITY AUDIT REPORT"
date

getent group security-admins
getent group security-analysts
getent group security-users

ls -la /opt/security/
sudo ufw status
🛡️ Step 3.3: Policy Enforcement Script
nano enforce-policies.sh
chmod +x enforce-policies.sh
📄 Policy Script
#!/bin/bash

echo "🔐 Enforcing security policies..."

sudo chmod 644 /etc/passwd
sudo chmod 640 /etc/shadow
sudo chmod 440 /etc/sudoers

sudo ufw --force enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "✅ Policies enforced"
🧪 Step 3.4: Test Scripts
./create-security-user.sh test analyst
./security-audit.sh
./enforce-policies.sh
🧠 TASK 4 — Master Security Manager
⚙️ Step 4.1: Create Manager Script
nano security-manager.sh
chmod +x security-manager.sh
📄 Manager Script
#!/bin/bash

echo "🛡️ DEFENSE-IN-DEPTH SECURITY MANAGER"

echo "1. Create User"
echo "2. Run Audit"
echo "3. Enforce Policies"
echo "4. Exit"

read choice

case $choice in
  1) ./create-security-user.sh ;;
  2) ./security-audit.sh ;;
  3) ./enforce-policies.sh ;;
  4) exit ;;
esac
▶️ Run Manager
./security-manager.sh
🔐 SECURITY VERIFICATION
getent group security-admins
ls -la /opt/security/
./security-audit.sh
📂 FINAL STRUCTURE
defense-lab/
│
├── defense-concepts.txt
├── create-security-user.sh
├── security-audit.sh
├── enforce-policies.sh
└── security-manager.sh
🎯 EXPECTED OUTCOMES

✔ Understanding layered security
✔ RBAC implementation in Linux
✔ Automated security enforcement
✔ System auditing capabilities
✔ Secure system configuration

🧠 KEY TAKEAWAYS
Security must be layered (not single point protection)
RBAC reduces privilege misuse
Automation improves security consistency
Regular audits detect misconfigurations
Defense-in-depth = resilience strategy
