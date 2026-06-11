# 🛡️ Building a Secure Network Architecture 

<div align="center">

![Linux](https://img.shields.io/badge/Linux-Ubuntu_20.04+-E95420?style=for-the-badge&logo=ubuntu)
![Security](https://img.shields.io/badge/Network-Security-blue?style=for-the-badge&logo=shield)
![iptables](https://img.shields.io/badge/Firewall-iptables-red?style=for-the-badge)
![Automation](https://img.shields.io/badge/Automation-Bash-green?style=for-the-badge&logo=gnubash)
![Lab](https://img.shields.io/badge/Type-Cybersecurity%20Lab-purple?style=for-the-badge)

</div>

---

## 🚀 Lab Overview

This lab demonstrates how to design and implement a **Secure Network Architecture** using Linux tools such as `iptables`, virtual interfaces, and automation scripts.

You will build a segmented network with **DMZ, Internal, and Management zones**, enforce firewall rules, and automate everything using Bash scripting.

---

## 🎯 Objectives

By the end of this lab, you will be able to:

🔹 Understand network segmentation and security benefits  
🔹 Configure `iptables` rules for traffic control  
🔹 Implement firewall-based network isolation  
🔹 Automate network configuration using scripts  
🔹 Apply secure network architecture best practices  
🔹 Troubleshoot segmentation and routing issues  

---

## 🧰 Prerequisites

✔ Linux command line basics  
✔ Networking fundamentals (IP, subnet, ports)  
✔ Basic shell scripting  
✔ TCP/IP understanding  
✔ sudo/root access  

---

## 🖥️ Lab Environment

You are provided with a pre-configured cloud lab:

- Ubuntu 20.04+ 🐧  
- iptables pre-installed 🔥  
- Network simulation tools 🌐  
- Text editors (nano, vim) ✍️  
- Root privileges 🔑  

---

# 🧪 LAB TASKS

---

# 🧱 Task 1: Network Segmentation Setup

---

## 🔍 Step 1.1: Check Current Network Configuration

```bash
ip addr show
ip route show
sudo iptables -L -v -n
netstat -tuln
🌐 Step 1.2: Create Virtual Network Segments
🟠 DMZ Network
sudo ip link add name dmz0 type dummy
sudo ip addr add 192.168.10.1/24 dev dmz0
sudo ip link set dmz0 up
🔵 Internal Network
sudo ip link add name internal0 type dummy
sudo ip addr add 192.168.20.1/24 dev internal0
sudo ip link set internal0 up
🟢 Management Network
sudo ip link add name mgmt0 type dummy
sudo ip addr add 192.168.30.1/24 dev mgmt0
sudo ip link set mgmt0 up
⚡ Step 1.3: Enable IP Forwarding
sudo sysctl net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
cat /proc/sys/net/ipv4/ip_forward
🔥 Task 2: Firewall & iptables Security Rules
🧹 Step 2.1: Clean Existing Rules
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
🧱 Step 2.2: Network Segmentation Script

Create file:

nano ~/network_segmentation.sh
📜 Script Content
#!/bin/bash

echo "🛡️ Applying Network Segmentation Rules..."

DMZ_NET="192.168.10.0/24"
INTERNAL_NET="192.168.20.0/24"
MGMT_NET="192.168.30.0/24"

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# DMZ Access
iptables -A FORWARD -d $DMZ_NET -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -d $DMZ_NET -p tcp --dport 443 -j ACCEPT

# SSH from MGMT
iptables -A FORWARD -s $MGMT_NET -d $DMZ_NET -p tcp --dport 22 -j ACCEPT

# Block DMZ → Internal
iptables -A FORWARD -s $DMZ_NET -d $INTERNAL_NET -j DROP

# MGMT full access
iptables -A FORWARD -s $MGMT_NET -j ACCEPT

# Logging
iptables -A FORWARD -j LOG --log-prefix "DROPPED: "
iptables -A FORWARD -j DROP

echo "✅ Rules Applied Successfully"
▶️ Run Script
chmod +x ~/network_segmentation.sh
sudo ~/network_segmentation.sh
🧪 Task 3: Testing Network Security
🧾 Test Script
nano ~/test_segmentation.sh
#!/bin/bash

echo "🧪 Testing Network Rules..."

iptables -I FORWARD 1 -d 192.168.10.0/24 -p tcp --dport 80 -j LOG --log-prefix "HTTP_DMZ: "
iptables -I FORWARD 1 -s 192.168.10.0/24 -d 192.168.20.0/24 -j LOG --log-prefix "BLOCK_DMZ_INT: "
iptables -I FORWARD 1 -s 192.168.30.0/24 -d 192.168.10.0/24 -p tcp --dport 22 -j LOG --log-prefix "MGMT_SSH: "

echo "✔ Test rules added"
📡 Monitor Logs
sudo tail -f /var/log/kern.log | grep DROPPED
🤖 Task 4: Automation Script
⚙️ Automated Setup Script
nano ~/automated_network_setup.sh

✔ Creates interfaces
✔ Configures iptables
✔ Enables forwarding
✔ Adds logging
✔ Creates cleanup tools

Run:

chmod +x ~/automated_network_setup.sh
sudo ~/automated_network_setup.sh
📊 Task 5: Network Validation
✅ Validation Script
nano ~/validate_network.sh

Checks:

✔ Interfaces
✔ ip_forward
✔ firewall rules
✔ segmentation rules
✔ logging system

Run:

chmod +x ~/validate_network.sh
sudo ~/validate_network.sh
📡 Task 6: Network Dashboard
nano ~/network_dashboard.sh

Features:

📊 Interface status
🔥 Firewall rules
📡 Live logs
📈 network stats

Run:

chmod +x ~/network_dashboard.sh
sudo ~/network_dashboard.sh
⚠️ Troubleshooting
🧩 Issue: Interfaces not created
sudo modprobe dummy
🧩 Issue: iptables not working
sudo iptables -S
🧩 Issue: IP forwarding disabled
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
📌 Verification
ip addr show | grep dmz
sudo iptables -L -v -n
cat /proc/sys/net/ipv4/ip_forward
🧠 Conclusion

You successfully built a:

✔ Segmented network (DMZ / Internal / Management)
✔ Firewall-controlled architecture
✔ Automated security scripts
✔ Monitoring dashboard
✔ Validation system

🔐 Why This Matters

Network segmentation is a core principle of modern cybersecurity used in:

Enterprise security systems 🏢
Cloud environments ☁️
Compliance frameworks (PCI-DSS, HIPAA) 📜
Zero Trust architectures 🛡️
🚀 Final Outcome

You now have a fully automated secure network architecture with:

🔥 Isolation
🔥 Firewall protection
🔥 Monitoring
🔥 Automation
🔥 Validation
