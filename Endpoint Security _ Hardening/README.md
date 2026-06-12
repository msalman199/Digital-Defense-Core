# 🔐 Endpoint Security & Hardening 

![Linux](https://img.shields.io/badge/Linux-Ubuntu-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![SSH](https://img.shields.io/badge/SSH-Key%20Auth-4D4D4D?style=for-the-badge&logo=openssh&logoColor=white)
![Fail2Ban](https://img.shields.io/badge/Fail2Ban-Brute%20Force%20Protection-red?style=for-the-badge&logo=shield&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![UFW](https://img.shields.io/badge/UFW-Firewall-orange?style=for-the-badge&logo=iptables&logoColor=white)
![Cron](https://img.shields.io/badge/Cron-Automation-blue?style=for-the-badge&logo=clockify&logoColor=white)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

- 🔑 Configure **secure SSH access** with key-based authentication
- 🚫 Install and configure **fail2ban** to protect against brute force attacks
- 📊 Create **monitoring scripts** to detect unauthorized access attempts
- 🛡️ Implement **basic endpoint hardening** techniques on Linux systems
- 👁️ Understand the importance of **proactive security monitoring**

---

## ✅ Prerequisites

| Requirement | Description |
|---|---|
| 🖥️ Linux CLI | Basic knowledge of Linux command line operations |
| 🔒 Permissions | Understanding of file permissions and ownership concepts |
| ✏️ Text Editor | Familiarity with `nano` or `vim` |
| 🌐 SSH Protocol | Basic understanding of SSH protocol |
| 📋 Log Files | Knowledge of log file locations in Linux systems |

---

## 🧪 Lab Environment

> 💡 **Al Nafi** provides Linux-based cloud machines for this lab.  
> Click **Start Lab** to access your pre-configured **Ubuntu** environment.  
> No need to build your own VM or set up additional infrastructure.

---

# 📋 Task 1 — Secure SSH Access Configuration

![SSH](https://img.shields.io/badge/SSH-Key%20Pair%20Setup-4D4D4D?style=flat-square&logo=openssh&logoColor=white)
![Security](https://img.shields.io/badge/Auth-Key%20Based-brightgreen?style=flat-square)

---

## 🔑 Subtask 1.1 — Create SSH Key Pair

🖥️ **Open a terminal on your Linux machine**

🔐 **Generate a secure SSH key pair:**

```bash
ssh-keygen -t rsa -b 4096 -C "lab-user@endpoint-security"
```

> 📝 When prompted for file location, press **Enter** to accept the default.  
> 🔒 Set a **strong passphrase** when prompted — remember it!

✅ **Verify key generation by listing the SSH directory:**

```bash
ls -la ~/.ssh/
```

> You should see two files:
> - `id_rsa` → 🔴 Private key
> - `id_rsa.pub` → 🟢 Public key

---

## ⚙️ Subtask 1.2 — Configure SSH Key Authentication

📋 **Copy the public key to the authorized keys file:**

```bash
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

🔒 **Set proper permissions on SSH files:**

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

---

## 🛡️ Subtask 1.3 — Harden SSH Configuration

💾 **Backup the original SSH configuration:**

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

✏️ **Edit the SSH configuration file:**

```bash
sudo nano /etc/ssh/sshd_config
```

📄 **Modify or add the following security settings:**

```bash
# Change default port (optional but recommended)
Port 2222

# Disable root login
PermitRootLogin no

# Enable public key authentication
PubkeyAuthentication yes

# Disable password authentication
PasswordAuthentication no

# Disable empty passwords
PermitEmptyPasswords no

# Limit login attempts
MaxAuthTries 3

# Set login grace time
LoginGraceTime 60

# Disable X11 forwarding if not needed
X11Forwarding no

# Use protocol 2 only
Protocol 2

# Allow specific users only (replace with your username)
AllowUsers $USER
```

🧪 **Test SSH configuration for syntax errors:**

```bash
sudo sshd -t
```

🔄 **If no errors, restart the SSH service:**

```bash
sudo systemctl restart ssh
```

✅ **Verify SSH service status:**

```bash
sudo systemctl status ssh
```

---

# 📋 Task 2 — Install and Configure fail2ban

![Fail2Ban](https://img.shields.io/badge/Fail2Ban-Install%20%26%20Configure-red?style=flat-square)
![SSH](https://img.shields.io/badge/SSH-Brute%20Force%20Protection-4D4D4D?style=flat-square&logo=openssh&logoColor=white)

---

## 📦 Subtask 2.1 — Install fail2ban

🔄 **Update the package repository:**

```bash
sudo apt update
```

📥 **Install fail2ban:**

```bash
sudo apt install fail2ban -y
```

✅ **Verify the installation:**

```bash
sudo systemctl status fail2ban
```

---

## ⚙️ Subtask 2.2 — Configure fail2ban for SSH Protection

✏️ **Create a local configuration file:**

```bash
sudo nano /etc/fail2ban/jail.local
```

📄 **Add the following configuration:**

```ini
[DEFAULT]
# Ban time in seconds (10 minutes)
bantime = 600

# Find time window in seconds (10 minutes)
findtime = 600

# Number of failures before ban
maxretry = 3

# Ignore local IP addresses
ignoreip = 127.0.0.1/8 ::1

[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 1800
findtime = 600
```

🔄 **Restart fail2ban to apply the configuration:**

```bash
sudo systemctl restart fail2ban
```

🚀 **Enable fail2ban to start on boot:**

```bash
sudo systemctl enable fail2ban
```

---

## 🔍 Subtask 2.3 — Verify fail2ban Configuration

📊 **Check fail2ban status:**

```bash
sudo fail2ban-client status
```

🔎 **Check SSH jail status specifically:**

```bash
sudo fail2ban-client status sshd
```

📋 **View fail2ban log to ensure it's working:**

```bash
sudo tail -f /var/log/fail2ban.log
```

> Press `Ctrl+C` to stop viewing the log.

---

# 📋 Task 3 — Create Monitoring Scripts for Unauthorized Access

![Bash](https://img.shields.io/badge/Bash-Monitoring%20Scripts-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Cron](https://img.shields.io/badge/Cron-Automated%20Checks-blue?style=flat-square)

---

## 📁 Subtask 3.1 — Create SSH Login Monitor Script

📁 **Create a directory for security scripts:**

```bash
mkdir ~/security-scripts
cd ~/security-scripts
```

✏️ **Create the SSH login monitoring script:**

```bash
nano ssh-monitor.sh
```

🐚 **Add the following script content:**

```bash
#!/bin/bash

# SSH Login Monitor Script
# This script monitors SSH login attempts and alerts on suspicious activity

LOG_FILE="/var/log/auth.log"
ALERT_FILE="$HOME/security-scripts/ssh-alerts.log"
TEMP_FILE="/tmp/ssh-check.tmp"

# Function to log alerts
log_alert() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ALERT_FILE"
}

# Function to check for failed SSH attempts
check_failed_logins() {
    echo "Checking for failed SSH login attempts..."
    
    FAILED_ATTEMPTS=$(grep "$(date '+%b %d %H')" "$LOG_FILE" | grep "Failed password" | wc -l)
    
    if [ "$FAILED_ATTEMPTS" -gt 5 ]; then
        ALERT_MSG="HIGH ALERT: $FAILED_ATTEMPTS failed SSH login attempts detected in the last hour"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
        grep "$(date '+%b %d %H')" "$LOG_FILE" | grep "Failed password" | tail -10 >> "$ALERT_FILE"
    else
        echo "Normal activity: $FAILED_ATTEMPTS failed attempts in the last hour"
    fi
}

# Function to check for successful logins
check_successful_logins() {
    echo "Checking for successful SSH logins..."
    
    SUCCESSFUL_LOGINS=$(grep "$(date '+%b %d %H')" "$LOG_FILE" | grep "Accepted" | wc -l)
    
    if [ "$SUCCESSFUL_LOGINS" -gt 0 ]; then
        echo "INFO: $SUCCESSFUL_LOGINS successful SSH logins in the last hour"
        log_alert "INFO: $SUCCESSFUL_LOGINS successful SSH logins detected"
        grep "$(date '+%b %d %H')" "$LOG_FILE" | grep "Accepted" >> "$ALERT_FILE"
    fi
}

# Function to check for unusual login times
check_unusual_times() {
    CURRENT_HOUR=$(date '+%H')
    
    if [ "$CURRENT_HOUR" -ge 0 ] && [ "$CURRENT_HOUR" -le 6 ]; then
        NIGHT_ATTEMPTS=$(grep "$(date '+%b %d')" "$LOG_FILE" | grep -E "(0[0-6]):" | grep -E "(Failed|Accepted)" | wc -l)
        
        if [ "$NIGHT_ATTEMPTS" -gt 0 ]; then
            ALERT_MSG="SUSPICIOUS: $NIGHT_ATTEMPTS login attempts during unusual hours (00:00-06:00)"
            echo "$ALERT_MSG"
            log_alert "$ALERT_MSG"
        fi
    fi
}

# Main execution
echo "=== SSH Security Monitor Started at $(date) ==="
log_alert "SSH Security Monitor Started"

check_failed_logins
check_successful_logins
check_unusual_times

echo "=== SSH Security Monitor Completed ==="
echo "Check $ALERT_FILE for detailed alerts"
```

🔐 **Make the script executable:**

```bash
chmod +x ssh-monitor.sh
```

---

## 🖥️ Subtask 3.2 — Create System Access Monitor Script

✏️ **Create a system access monitoring script:**

```bash
nano system-monitor.sh
```

🐚 **Add the following script content:**

```bash
#!/bin/bash

# System Access Monitor Script
# Monitors various system access points and user activities

ALERT_FILE="$HOME/security-scripts/system-alerts.log"
LOG_FILE="/var/log/auth.log"

log_alert() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ALERT_FILE"
}

# Check for sudo usage
check_sudo_usage() {
    echo "Checking sudo usage..."
    SUDO_ATTEMPTS=$(grep "$(date '+%b %d')" "$LOG_FILE" | grep "sudo" | wc -l)
    
    if [ "$SUDO_ATTEMPTS" -gt 10 ]; then
        ALERT_MSG="WARNING: High sudo usage detected - $SUDO_ATTEMPTS attempts today"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
    else
        echo "Normal sudo usage: $SUDO_ATTEMPTS attempts today"
    fi
}

# Check for new user accounts
check_new_users() {
    echo "Checking for recently created user accounts..."
    RECENT_USERS=$(find /home -maxdepth 1 -type d -newerct "1 day ago" | grep -v "^/home$" | wc -l)
    
    if [ "$RECENT_USERS" -gt 0 ]; then
        ALERT_MSG="ALERT: $RECENT_USERS new user directories detected in the last 24 hours"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
        find /home -maxdepth 1 -type d -newerct "1 day ago" | grep -v "^/home$" >> "$ALERT_FILE"
    fi
}

# Check for failed su attempts
check_su_attempts() {
    echo "Checking for su (switch user) attempts..."
    SU_FAILURES=$(grep "$(date '+%b %d')" "$LOG_FILE" | grep "su:" | grep "FAILED" | wc -l)
    
    if [ "$SU_FAILURES" -gt 0 ]; then
        ALERT_MSG="WARNING: $SU_FAILURES failed su attempts detected today"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
    fi
}

# Check system load
check_system_load() {
    echo "Checking system load..."
    LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    LOAD_THRESHOLD=2.0
    
    if (( $(echo "$LOAD_AVG > $LOAD_THRESHOLD" | bc -l) )); then
        ALERT_MSG="WARNING: High system load detected - $LOAD_AVG"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
    else
        echo "System load normal: $LOAD_AVG"
    fi
}

# Check disk usage
check_disk_usage() {
    echo "Checking disk usage..."
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "$DISK_USAGE" -gt 80 ]; then
        ALERT_MSG="WARNING: High disk usage detected - ${DISK_USAGE}%"
        echo "$ALERT_MSG"
        log_alert "$ALERT_MSG"
    else
        echo "Disk usage normal: ${DISK_USAGE}%"
    fi
}

# Main execution
echo "=== System Security Monitor Started at $(date) ==="
log_alert "System Security Monitor Started"

check_sudo_usage
check_new_users
check_su_attempts
check_system_load
check_disk_usage

echo "=== System Security Monitor Completed ==="
echo "Check $ALERT_FILE for detailed alerts"
```

🔐 **Make the script executable:**

```bash
chmod +x system-monitor.sh
```

---

## ⏰ Subtask 3.3 — Create Automated Monitoring with Cron

✏️ **Create a master monitoring script:**

```bash
nano security-check.sh
```

🐚 **Add the following content:**

```bash
#!/bin/bash

# Master Security Check Script
# Runs all security monitoring scripts

SCRIPT_DIR="$HOME/security-scripts"
LOG_FILE="$SCRIPT_DIR/security-master.log"

echo "=== Security Check Started at $(date) ===" >> "$LOG_FILE"

echo "Running SSH Monitor..." >> "$LOG_FILE"
"$SCRIPT_DIR/ssh-monitor.sh" >> "$LOG_FILE" 2>&1

echo "" >> "$LOG_FILE"

echo "Running System Monitor..." >> "$LOG_FILE"
"$SCRIPT_DIR/system-monitor.sh" >> "$LOG_FILE" 2>&1

echo "=== Security Check Completed at $(date) ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Keep only last 1000 lines of log to prevent it from growing too large
tail -1000 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
```

🔐 **Make the script executable:**

```bash
chmod +x security-check.sh
```

⏱️ **Set up a cron job to run the security check every hour:**

```bash
crontab -e
```

➕ **Add the following line:**

```bash
0 * * * * /home/$USER/security-scripts/security-check.sh
```

> 💾 Save and exit the crontab editor.

---

# 📋 Task 4 — Test and Verify Security Measures

![Testing](https://img.shields.io/badge/Test-SSH%20Security-blue?style=flat-square)
![Verify](https://img.shields.io/badge/Verify-Monitoring%20Scripts-green?style=flat-square)

---

## 🔌 Subtask 4.1 — Test SSH Security

🔗 **Test SSH configuration by connecting with the new port:**

```bash
ssh -p 2222 $USER@localhost
```

🔒 **Verify that password authentication is disabled** by trying to connect without keys.

🔍 **Check fail2ban is monitoring SSH:**

```bash
sudo fail2ban-client status sshd
```

---

## 🧪 Subtask 4.2 — Test Monitoring Scripts

▶️ **Run the SSH monitoring script manually:**

```bash
cd ~/security-scripts
./ssh-monitor.sh
```

▶️ **Run the system monitoring script:**

```bash
./system-monitor.sh
```

📋 **Check the generated alert files:**

```bash
ls -la ~/security-scripts/*.log
cat ~/security-scripts/ssh-alerts.log
cat ~/security-scripts/system-alerts.log
```

---

## 🎭 Subtask 4.3 — Generate Test Events

🧪 **Simulate a failed login attempt in the auth log:**

```bash
logger -p auth.info "Failed password for testuser from 192.168.1.100 port 22 ssh2"
```

🔁 **Run the monitoring script again to detect the test event:**

```bash
./ssh-monitor.sh
```

📋 **Check the alert file for the new entry:**

```bash
tail ~/security-scripts/ssh-alerts.log
```

---

# 📋 Task 5 — Additional Hardening Measures

![UFW](https://img.shields.io/badge/UFW-Firewall%20Rules-orange?style=flat-square)
![Integrity](https://img.shields.io/badge/File-Integrity%20Monitor-purple?style=flat-square)

---

## 🔥 Subtask 5.1 — Configure Firewall Rules

🚀 **Install and enable UFW:**

```bash
sudo ufw enable
```

🛡️ **Set default policies:**

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

🔓 **Allow SSH on the custom port:**

```bash
sudo ufw allow 2222/tcp
```

✅ **Check firewall status:**

```bash
sudo ufw status verbose
```

---

## 📁 Subtask 5.2 — Set Up File Integrity Monitoring

✏️ **Create a simple file integrity checker:**

```bash
nano ~/security-scripts/file-integrity.sh
```

🐚 **Add the following script:**

```bash
#!/bin/bash

# File Integrity Monitor
# Monitors critical system files for changes

MONITOR_DIRS="/etc/ssh /etc/passwd /etc/shadow /etc/sudoers"
BASELINE_FILE="$HOME/security-scripts/file-baseline.txt"
ALERT_FILE="$HOME/security-scripts/integrity-alerts.log"

log_alert() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ALERT_FILE"
}

# Create baseline if it doesn't exist
if [ ! -f "$BASELINE_FILE" ]; then
    echo "Creating file integrity baseline..."
    for dir in $MONITOR_DIRS; do
        if [ -e "$dir" ]; then
            find "$dir" -type f -exec md5sum {} \; >> "$BASELINE_FILE"
        fi
    done
    echo "Baseline created at $BASELINE_FILE"
    log_alert "File integrity baseline created"
    exit 0
fi

# Check for changes
echo "Checking file integrity..."
TEMP_FILE="/tmp/current-hashes.txt"

for dir in $MONITOR_DIRS; do
    if [ -e "$dir" ]; then
        find "$dir" -type f -exec md5sum {} \; >> "$TEMP_FILE"
    fi
done

# Compare with baseline
if ! diff -q "$BASELINE_FILE" "$TEMP_FILE" > /dev/null; then
    ALERT_MSG="WARNING: File integrity changes detected!"
    echo "$ALERT_MSG"
    log_alert "$ALERT_MSG"
    diff "$BASELINE_FILE" "$TEMP_FILE" >> "$ALERT_FILE"
else
    echo "File integrity check passed - no changes detected"
fi

rm -f "$TEMP_FILE"
```

🔐 **Make the script executable:**

```bash
chmod +x ~/security-scripts/file-integrity.sh
```

📊 **Create the initial baseline:**

```bash
~/security-scripts/file-integrity.sh
```

🧪 **Test the integrity checker:**

```bash
~/security-scripts/file-integrity.sh
```

---

# 🔍 Verification and Testing

## ✅ Final Security Check

🔎 **Verify all services are running correctly:**

```bash
sudo systemctl status ssh
sudo systemctl status fail2ban
sudo ufw status
```

📋 **Check that monitoring scripts are working:**

```bash
ls -la ~/security-scripts/
cat ~/security-scripts/security-master.log
```

📅 **Verify cron job is scheduled:**

```bash
crontab -l
```

▶️ **Test the complete security setup by running the master script:**

```bash
~/security-scripts/security-check.sh
```

---

# 🔧 Troubleshooting Common Issues

<details>
<summary>🔴 SSH Connection Issues</summary>

Check if the SSH service is running:

```bash
sudo systemctl status ssh
```

Verify the configuration syntax:

```bash
sudo sshd -t
```

Check the SSH log for errors:

```bash
sudo tail -f /var/log/auth.log
```

</details>

<details>
<summary>🔴 fail2ban Not Working</summary>

Check fail2ban status:

```bash
sudo fail2ban-client status
```

Verify the jail configuration:

```bash
sudo fail2ban-client get sshd logpath
```

Check fail2ban logs:

```bash
sudo tail -f /var/log/fail2ban.log
```

</details>

<details>
<summary>🔴 Script Permission Issues</summary>

If scripts are not executable, run:

```bash
chmod +x ~/security-scripts/*.sh
```

</details>

---

# ✅ Expected Outcomes

After completing this lab, you should have:

- ✅ **Secure SSH** with key-based authentication configured
- ✅ **fail2ban** actively protecting against brute force attacks
- ✅ **SSH & system monitoring scripts** detecting unauthorized access
- ✅ **File integrity monitoring** tracking changes to critical files
- ✅ **UFW firewall** controlling inbound/outbound network traffic
- ✅ **Automated cron job** running security checks every hour

---

# 🎓 Conclusion

In this lab, you successfully implemented comprehensive **endpoint security and hardening** measures on a Linux system. Here's a summary of what was accomplished:

| Area | Achievement |
|---|---|
| 🔑 SSH Security | Key-based auth, disabled passwords, changed port, restricted users |
| 🚫 Intrusion Prevention | fail2ban configured to auto-ban brute force IPs |
| 📊 Proactive Monitoring | Scripts tracking SSH attempts, sudo usage, disk & load |
| 📁 File Integrity | Baseline hashing to detect unauthorized system file changes |
| 🔥 Network Security | UFW firewall restricting inbound access |
| ⏰ Automation | Cron jobs ensuring continuous, unattended monitoring |

---

## 💡 Key Takeaways

| # | Takeaway |
|---|---|
| 🔑 | Use **key-based SSH authentication** — disable password login |
| 🚫 | **fail2ban** provides real-time automated brute force protection |
| 👁️ | **Proactive monitoring** is essential for early threat detection |
| 🧱 | **Layered defense** — multiple controls working together |
| 🔁 | **Automate security checks** to ensure continuous coverage |
| 📋 | **Review logs regularly** — alerts only help if someone reads them |

---

## 🚀 Next Steps

![SIEM](https://img.shields.io/badge/Next-SIEM%20Integration-blue?style=flat-square)
![IDS](https://img.shields.io/badge/Next-IDS%2FIPS%20Systems-orange?style=flat-square)
![Audit](https://img.shields.io/badge/Next-Linux%20Auditd-purple?style=flat-square)
![CIS](https://img.shields.io/badge/Next-CIS%20Benchmarks-red?style=flat-square)

- 🔵 Explore **SIEM integration** for centralized log management
- 🟠 Study **IDS/IPS systems** like Snort or Suricata
- 🟣 Learn **Linux Auditd** for detailed system call auditing
- 🔴 Apply **CIS Benchmarks** for comprehensive hardening checklists

---

<div align="center">

![Made with](https://img.shields.io/badge/Made%20with-❤️%20for%20Security-blueviolet?style=for-the-badge)
![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Lab%20Guide-0077B5?style=for-the-badge)

</div>
