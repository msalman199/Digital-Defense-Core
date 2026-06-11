# 🔒 VPN Configuration and TLS

> A hands-on network security lab covering OpenVPN server setup, PKI certificate management, TLS traffic analysis, Wireshark packet capture, and advanced TLS testing — on a Linux cloud machine.

![OpenVPN](https://img.shields.io/badge/OpenVPN-Server%20%2B%20Client-FF6B6B?style=for-the-badge&logo=openvpn&logoColor=white)
![TLS](https://img.shields.io/badge/TLS-1.2%20%7C%201.3-4CAF50?style=for-the-badge&logo=letsencrypt&logoColor=white)
![PKI](https://img.shields.io/badge/PKI-Easy--RSA%20CA-FF9800?style=for-the-badge&logo=shield&logoColor=white)
![Wireshark](https://img.shields.io/badge/Wireshark-Traffic%20Analysis-1679A7?style=for-the-badge&logo=wireshark&logoColor=white)
![AES](https://img.shields.io/badge/AES--256--GCM-Encryption-9C27B0?style=for-the-badge&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![curl](https://img.shields.io/badge/curl-TLS%20Testing-2196F3?style=for-the-badge&logo=curl&logoColor=white)
![iptables](https://img.shields.io/badge/iptables-Firewall%20%7C%20NAT-607D8B?style=for-the-badge&logoColor=white)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

- ✅ Understand the fundamentals of **VPN technology** and **TLS encryption**
- ✅ Install and configure an **OpenVPN server** on a Linux system
- ✅ Create and manage **VPN certificates and keys** using Easy-RSA
- ✅ Establish **VPN connections** using OpenVPN client
- ✅ **Test and verify** VPN connectivity using command-line tools
- ✅ Analyze **VPN and TLS traffic** using Wireshark
- ✅ **Troubleshoot** common VPN configuration issues
- ✅ Validate **TLS connections** using curl with various security options

---

## 📋 Prerequisites

| Requirement | Level |
|---|---|
| 🖥️ Linux Command Line Operations | Basic |
| 🌐 Network Concepts (IP, Routing, DNS) | Basic |
| 🔐 File Permissions and Text Editing | Basic |
| 🔑 Basic Cryptography (Certificates, Keys) | Basic |
| 📦 Linux Package Management | Basic |

---

## 🌐 Lab Environment

> **Al Nafi** provides Linux-based cloud machines for this lab.  
> Click **Start Lab** to access your pre-configured **Ubuntu** environment.  
> All tasks are performed on a **single Linux machine** — no additional infrastructure needed.

---

## 🗂️ Lab Structure

```
VPN Lab Overview
│
├── 🔧 Task 1 — OpenVPN Server Setup
│   ├── Subtask 1.1  Install OpenVPN + Easy-RSA
│   ├── Subtask 1.2  Build Certificate Authority
│   ├── Subtask 1.3  Generate Server Certificate + Key
│   ├── Subtask 1.4  Generate Client Certificate + Key
│   ├── Subtask 1.5  Copy Certs to OpenVPN Directory
│   ├── Subtask 1.6  Create Server Configuration
│   ├── Subtask 1.7  Configure IP Forwarding + Firewall
│   ├── Subtask 1.8  Start + Enable OpenVPN Service
│   └── Subtask 1.9  Create Client Config File
│
└── 🔍 Task 2 — Test VPN and TLS
    ├── Subtask 2.1  Install Wireshark + tshark
    ├── Subtask 2.2  Test VPN Connection
    ├── Subtask 2.3  Capture VPN Traffic
    ├── Subtask 2.4  Test TLS with curl
    ├── Subtask 2.5  Capture + Analyze TLS Traffic
    ├── Subtask 2.6  VPN Performance + Security Tests
    ├── Subtask 2.7  Advanced TLS Testing
    └── Subtask 2.8  Verification + Cleanup
```

---

## 🔧 Task 1 — Set Up a VPN Using OpenVPN on Linux

![Task](https://img.shields.io/badge/Task-1%20of%202-FF5722?style=flat-square)
![Tool](https://img.shields.io/badge/Tool-OpenVPN%20%7C%20Easy--RSA-FF6B6B?style=flat-square)
![Cipher](https://img.shields.io/badge/Cipher-AES--256--GCM-4CAF50?style=flat-square)

---

### 📦 Subtask 1.1 — Install OpenVPN and Easy-RSA

```bash
# Update package repositories
sudo apt update

# Install OpenVPN and Easy-RSA
sudo apt install -y openvpn easy-rsa

# Verify installation
openvpn --version
```

---

### 🏛️ Subtask 1.2 — Set Up the Certificate Authority (CA)

```bash
# Create Easy-RSA directory
mkdir ~/easy-rsa
cd ~/easy-rsa

# Copy Easy-RSA files
cp -r /usr/share/easy-rsa/* .

# Initialize the PKI (Public Key Infrastructure)
./easyrsa init-pki

# Build the Certificate Authority
./easyrsa build-ca nopass
```

> 📝 When prompted for the **Common Name**, enter: `VPN-Lab-CA`

---

### 🔑 Subtask 1.3 — Generate Server Certificate and Key

```bash
# Generate server certificate request and key
./easyrsa gen-req vpn-server nopass

# Sign the server certificate
./easyrsa sign-req server vpn-server

# Generate Diffie-Hellman parameters (may take a few minutes)
./easyrsa gen-dh

# Generate TLS authentication key
openvpn --genkey secret pki/ta.key
```

> ⏳ The `gen-dh` step may take **several minutes** — this is normal.

---

### 👤 Subtask 1.4 — Generate Client Certificate and Key

```bash
# Generate client certificate request and key
./easyrsa gen-req vpn-client nopass

# Sign the client certificate
./easyrsa sign-req client vpn-client
```

---

### 📂 Subtask 1.5 — Copy Certificates to OpenVPN Directory

```bash
# Create OpenVPN server directory
sudo mkdir -p /etc/openvpn/server

# Copy server certificates and keys
sudo cp pki/ca.crt /etc/openvpn/server/
sudo cp pki/issued/vpn-server.crt /etc/openvpn/server/
sudo cp pki/private/vpn-server.key /etc/openvpn/server/
sudo cp pki/dh.pem /etc/openvpn/server/
sudo cp pki/ta.key /etc/openvpn/server/

# Create client certificates directory
mkdir ~/client-configs
cp pki/ca.crt ~/client-configs/
cp pki/issued/vpn-client.crt ~/client-configs/
cp pki/private/vpn-client.key ~/client-configs/
cp pki/ta.key ~/client-configs/
```

Certificate layout after this step:

```
/etc/openvpn/server/          ~/client-configs/
├── 📜 ca.crt                 ├── 📜 ca.crt
├── 📜 vpn-server.crt         ├── 📜 vpn-client.crt
├── 🔑 vpn-server.key         ├── 🔑 vpn-client.key
├── 📄 dh.pem                 └── 🔑 ta.key
└── 🔑 ta.key
```

---

### ⚙️ Subtask 1.6 — Create OpenVPN Server Configuration

```bash
sudo tee /etc/openvpn/server/server.conf > /dev/null << 'EOF'
# OpenVPN Server Configuration
port 1194
proto udp
dev tun

# SSL/TLS root certificate (ca), certificate (cert), and private key (key)
ca ca.crt
cert vpn-server.crt
key vpn-server.key

# Diffie hellman parameters
dh dh.pem

# Network topology
topology subnet

# Configure server mode and supply a VPN subnet
server 10.8.0.0 255.255.255.0

# Maintain a record of client <-> virtual IP address associations
ifconfig-pool-persist /var/log/openvpn/ipp.txt

# Push routes to the client
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"

# Enable compression on the VPN link
compress lz4-v2
push "compress lz4-v2"

# Keepalive
keepalive 10 120

# TLS authentication
tls-auth ta.key 0

# Cryptographic cipher
cipher AES-256-GCM
auth SHA256

# Minimum TLS version
tls-version-min 1.2

# Max concurrent clients
max-clients 10

# Reduced privileges
user nobody
group nogroup

# Persist options
persist-key
persist-tun

# Status and logging
status /var/log/openvpn/openvpn-status.log
verb 3
mute 20
explicit-exit-notify 1
EOF
```

Key configuration parameters:

| Setting | Value | Purpose |
|---|---|---|
| `port` | `1194/udp` | Standard OpenVPN port |
| `cipher` | `AES-256-GCM` | Strong symmetric encryption |
| `auth` | `SHA256` | HMAC authentication |
| `tls-version-min` | `1.2` | Enforce modern TLS |
| `server` | `10.8.0.0/24` | VPN subnet |
| `max-clients` | `10` | Concurrent connections |

---

### 🛡️ Subtask 1.7 — Configure IP Forwarding and Firewall

```bash
# Enable IP forwarding
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Create log directory
sudo mkdir -p /var/log/openvpn

# Configure UFW firewall
sudo ufw allow 1194/udp
sudo ufw allow OpenSSH

# Add NAT rule for VPN traffic
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
sudo iptables -A INPUT -i tun+ -j ACCEPT
sudo iptables -A FORWARD -i tun+ -j ACCEPT
sudo iptables -A FORWARD -i tun+ -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT

# Save iptables rules
sudo sh -c "iptables-save > /etc/iptables.rules"

# Create script to restore iptables on boot
sudo tee /etc/network/if-pre-up.d/iptables > /dev/null << 'EOF'
#!/bin/bash
/sbin/iptables-restore < /etc/iptables.rules
EOF

sudo chmod +x /etc/network/if-pre-up.d/iptables
```

Traffic flow after firewall configuration:

```
┌─────────────────────────────────────────────────────────┐
│                   VPN TRAFFIC FLOW                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  VPN Client  ──►  tun0 (10.8.0.x)  ──►  eth0          │
│                        │                    │           │
│                   ACCEPT (INPUT)      MASQUERADE        │
│                   ACCEPT (FORWARD)    (NAT/POSTROUTING) │
│                        │                    │           │
│                        └────────────────────┘           │
│                               ▼                         │
│                         Internet / LAN                  │
└─────────────────────────────────────────────────────────┘
```

---

### ▶️ Subtask 1.8 — Start and Enable OpenVPN Service

```bash
# Start OpenVPN server
sudo systemctl start openvpn-server@server

# Enable OpenVPN to start on boot
sudo systemctl enable openvpn-server@server

# Check service status
sudo systemctl status openvpn-server@server

# Verify VPN interface is created
ip addr show tun0
```

| Check | Expected Result |
|---|---|
| Service status | ✅ `active (running)` |
| `tun0` interface | ✅ Shows `10.8.0.1` address |

---

### 📄 Subtask 1.9 — Create Client Configuration File

```bash
# Create client configuration
tee ~/client-configs/client.ovpn > /dev/null << 'EOF'
client
dev tun
proto udp
remote 127.0.0.1 1194
resolv-retry infinite
nobind
persist-key
persist-tun
compress lz4-v2
cipher AES-256-GCM
auth SHA256
tls-version-min 1.2
key-direction 1
verb 3
mute 20
EOF

# Add certificates inline to client config
echo '<ca>' >> ~/client-configs/client.ovpn
cat ~/client-configs/ca.crt >> ~/client-configs/client.ovpn
echo '</ca>' >> ~/client-configs/client.ovpn

echo '<cert>' >> ~/client-configs/client.ovpn
cat ~/client-configs/vpn-client.crt >> ~/client-configs/client.ovpn
echo '</cert>' >> ~/client-configs/client.ovpn

echo '<key>' >> ~/client-configs/client.ovpn
cat ~/client-configs/vpn-client.key >> ~/client-configs/client.ovpn
echo '</key>' >> ~/client-configs/client.ovpn

echo '<tls-auth>' >> ~/client-configs/client.ovpn
cat ~/client-configs/ta.key >> ~/client-configs/client.ovpn
echo '</tls-auth>' >> ~/client-configs/client.ovpn
```

---

## 🔍 Task 2 — Test VPN and TLS Using curl and Wireshark

![Task](https://img.shields.io/badge/Task-2%20of%202-4CAF50?style=flat-square)
![Tool](https://img.shields.io/badge/Tools-Wireshark%20%7C%20tshark%20%7C%20curl-1679A7?style=flat-square)
![Capture](https://img.shields.io/badge/Feature-Packet%20Capture%20%7C%20TLS%20Analysis-FF9800?style=flat-square)

---

### 🦈 Subtask 2.1 — Install and Configure Wireshark

```bash
# Install Wireshark (non-interactive)
sudo DEBIAN_FRONTEND=noninteractive apt install -y wireshark tshark

# Add current user to wireshark group
sudo usermod -a -G wireshark $USER

# Install additional network tools
sudo apt install -y curl wget netcat-openbsd tcpdump
```

---

### 🔗 Subtask 2.2 — Test VPN Connection

```bash
# Test VPN connection in background
sudo openvpn --config ~/client-configs/client.ovpn --daemon --log /tmp/vpn-client.log

# Wait for connection to establish
sleep 10

# Check VPN connection status
ps aux | grep openvpn

# Verify VPN interface
ip addr show | grep -A 5 tun

# Test VPN connectivity
ping -c 3 10.8.0.1

# Check routing table
ip route | grep tun
```

| Test | Expected Result |
|---|---|
| `ps aux \| grep openvpn` | ✅ OpenVPN process running |
| `ip addr show tun` | ✅ VPN IP in `10.8.0.x` range |
| `ping 10.8.0.1` | ✅ 0% packet loss |
| `ip route \| grep tun` | ✅ Route via `tun0` present |

---

### 📡 Subtask 2.3 — Capture VPN Traffic with Wireshark

```bash
# Start packet capture on VPN interface (background)
sudo tshark -i tun0 -w /tmp/vpn_traffic.pcap &
TSHARK_PID=$!

# Generate some VPN traffic
ping -c 5 8.8.8.8

# Stop packet capture
sleep 5
sudo kill $TSHARK_PID

# Analyze captured VPN traffic
sudo tshark -r /tmp/vpn_traffic.pcap -V | head -50
```

---

### 🌐 Subtask 2.4 — Test TLS Connections with curl

```bash
# Test basic HTTPS connection
curl -v https://www.google.com 2>&1 | head -20

# Test TLS 1.2
echo "Testing TLS 1.2:"
curl -v --tlsv1.2 https://www.google.com 2>&1 | grep -E "(TLS|SSL)"

# Test TLS 1.3
echo "Testing TLS 1.3:"
curl -v --tlsv1.3 https://www.google.com 2>&1 | grep -E "(TLS|SSL)"

# Test certificate verification
echo "Testing certificate verification:"
curl -v --cacert /etc/ssl/certs/ca-certificates.crt \
  https://www.google.com 2>&1 | grep -E "(certificate|verify)"
```

| TLS Version | Flag | Expected Result |
|---|---|---|
| TLS 1.2 | `--tlsv1.2` | ✅ Handshake succeeds |
| TLS 1.3 | `--tlsv1.3` | ✅ Handshake succeeds |
| Cert verification | `--cacert` | ✅ Certificate verified |

---

### 🔬 Subtask 2.5 — Capture and Analyze TLS Traffic

```bash
# Start packet capture for TLS traffic
sudo tshark -i any -f "port 443" -w /tmp/tls_traffic.pcap &
TSHARK_TLS_PID=$!

# Generate TLS traffic
curl -s https://www.example.com > /dev/null

# Stop capture
sleep 3
sudo kill $TSHARK_TLS_PID

# Analyze TLS handshake
echo "TLS Handshake Analysis:"
sudo tshark -r /tmp/tls_traffic.pcap \
  -Y "tls.handshake.type" \
  -T fields \
  -e frame.number \
  -e tls.handshake.type \
  -e tls.handshake.version

# Show TLS certificate information
echo "Certificate Information:"
sudo tshark -r /tmp/tls_traffic.pcap \
  -Y "tls.handshake.certificate" -V | grep -A 10 "Certificate:"
```

TLS handshake types captured:

```
┌──────────────────────────────────────────────────────┐
│              TLS HANDSHAKE SEQUENCE                  │
├────────┬─────────────────────────────────────────────┤
│  Type  │  Message                                    │
├────────┼─────────────────────────────────────────────┤
│   1    │  ClientHello  →  proposes cipher suites     │
│   2    │  ServerHello  →  selects cipher suite       │
│  11    │  Certificate  →  server cert sent           │
│  12    │  ServerKeyExchange                          │
│  14    │  ServerHelloDone                            │
│  16    │  ClientKeyExchange                          │
│  20    │  Finished     →  handshake complete         │
└────────┴─────────────────────────────────────────────┘
```

---

### 🧪 Subtask 2.6 — VPN Performance and Security Tests

```bash
# Test DNS resolution through VPN
echo "DNS Resolution Test:"
nslookup google.com

# Test external IP address (should show VPN server IP)
echo "External IP Test:"
curl -s https://ipinfo.io/ip

# Capture OpenVPN encrypted traffic
echo "Capturing OpenVPN encrypted traffic:"
sudo tshark -i any -f "port 1194" -c 10 -w /tmp/openvpn_encrypted.pcap &
OPENVPN_PID=$!

# Generate traffic through VPN
ping -c 5 8.8.8.8 > /dev/null

sleep 5
sudo kill $OPENVPN_PID 2>/dev/null

# Analyze OpenVPN encrypted packets
echo "OpenVPN Encrypted Packet Analysis:"
sudo tshark -r /tmp/openvpn_encrypted.pcap \
  -T fields \
  -e frame.number \
  -e ip.src \
  -e ip.dst \
  -e udp.port \
  -e data
```

---

### 🔐 Subtask 2.7 — Advanced TLS Testing

```bash
# Test with AES-256-GCM cipher suite
echo "Testing AES-256-GCM cipher:"
curl -v --ciphers ECDHE-RSA-AES256-GCM-SHA384 \
  https://www.google.com 2>&1 | grep -E "(cipher|TLS)"

# Create a test client certificate
echo "Creating test client certificate:"
openssl req -x509 -newkey rsa:2048 \
  -keyout /tmp/client.key \
  -out /tmp/client.crt \
  -days 1 -nodes \
  -subj "/CN=test-client"

# Detailed TLS connection analysis
echo "Detailed TLS Connection Analysis:"
curl -v --trace-ascii /tmp/curl_trace.txt \
  https://www.example.com 2>&1 | grep -E "(TLS|SSL|cipher|protocol)"

# Show TLS trace sample
echo "TLS Trace Sample:"
head -20 /tmp/curl_trace.txt
```

---

### 🧹 Subtask 2.8 — VPN Connection Verification and Cleanup

```bash
# Check VPN server logs
echo "VPN Server Logs:"
sudo tail -10 /var/log/openvpn/openvpn-status.log

# Check client connection logs
echo "VPN Client Logs:"
tail -10 /tmp/vpn-client.log

# Test VPN tunnel integrity
echo "VPN Tunnel Test:"
traceroute -n 8.8.8.8 | head -5

# Stop VPN client
sudo pkill -f "openvpn.*client.ovpn"

# Verify VPN disconnection
sleep 3
ip addr show | grep tun || echo "VPN tunnel disconnected successfully"

# Display captured packet files
echo "Generated packet capture files:"
ls -la /tmp/*.pcap
```

---

## ✅ Expected Outcomes

After completing this lab, you should have:

| Achievement | Details | Status |
|---|---|---|
| 🔧 OpenVPN Server | Fully configured with PKI certificates | 📦 Task 1 |
| 🏛️ Certificate Authority | Root CA + server + client certs via Easy-RSA | 📦 Task 1 |
| 🔑 Key Management | DH params, TLS auth key, cert signing | 📦 Task 1 |
| 🛡️ Firewall Rules | UFW + iptables NAT for VPN traffic | 📦 Task 1 |
| 🔗 VPN Connection | Client connecting to server over `tun0` | 📦 Task 2 |
| 🦈 Packet Captures | VPN + TLS traffic in `.pcap` files | 📦 Task 2 |
| 🌐 TLS Testing | TLS 1.2/1.3 tested with curl flags | 📦 Task 2 |
| 🔐 Cipher Analysis | AES-256-GCM cipher suite verified | 📦 Task 2 |

### 📁 Generated Packet Capture Files

```
/tmp/
├── 📦 vpn_traffic.pcap          # VPN tunnel traffic (tun0)
├── 📦 tls_traffic.pcap          # TLS handshake on port 443
├── 📦 openvpn_encrypted.pcap    # Encrypted OpenVPN on port 1194
├── 📄 vpn-client.log            # OpenVPN client connection log
└── 📄 curl_trace.txt            # curl TLS trace output
```

---

## 🛠️ Troubleshooting

### ❗ OpenVPN Service Won't Start

```bash
# Check config syntax with verbose output
sudo openvpn --config /etc/openvpn/server/server.conf --verb 9

# Verify certificate file permissions
sudo ls -la /etc/openvpn/server/

# Check firewall rules
sudo ufw status
```

---

### ❗ Client Connection Fails

```bash
# Verify server is listening on port 1194
sudo netstat -ulnp | grep 1194

# Check certificate expiry
openssl x509 -in ~/client-configs/vpn-client.crt \
  -text -noout | grep "Not After"
```

> ✅ Verify the **client config file path and syntax** is correct

---

### ❗ No Internet Access Through VPN

```bash
# Verify IP forwarding is enabled
cat /proc/sys/net/ipv4/ip_forward   # Should output: 1

# Check iptables NAT rules
sudo iptables -t nat -L

# Verify DNS settings pushed to client
grep "dhcp-option DNS" /etc/openvpn/server/server.conf
```

---

### ❗ curl TLS Errors

```bash
# Update CA certificates
sudo apt update && sudo apt install ca-certificates

# Ignore cert errors for testing only
curl -k https://example.com

# Check TLS version support
curl --version | grep TLS
```

> ⚠️ Use `-k` flag **only for testing** — never in production

---

### ❗ Wireshark Capture Issues

```bash
# List available interfaces
sudo tshark -D

# Verify group membership
groups $USER | grep wireshark

# Capture with elevated privileges
sudo tshark -i tun0 -w /tmp/capture.pcap
```

---

## 📚 Key Takeaways

> 🔒 **VPN tunnels** protect data in transit by encrypting all traffic through `tun0`  
> 🏛️ **PKI certificates** provide mutual authentication for server and client  
> 🔐 **AES-256-GCM + SHA256** is a strong cipher + auth combination for OpenVPN  
> 📊 **Wireshark/tshark** can verify encryption — OpenVPN traffic on port 1194 should be unreadable  
> 🌐 **TLS 1.2 minimum** should be enforced — TLS 1.0/1.1 are deprecated and insecure  
> 🛡️ **iptables NAT masquerade** enables VPN clients to reach the internet through the server  

---

## 🔭 Next Steps

- [ ] 🌍 Configure OpenVPN for **remote access** from external networks
- [ ] 🔄 Explore **WireGuard** as a modern VPN alternative to OpenVPN
- [ ] 📜 Study **certificate revocation** (CRL / OCSP) for PKI management
- [ ] 🛡️ Implement **multi-factor authentication** with OpenVPN
- [ ] 🔍 Investigate **TLS fingerprinting** and JA3 signatures for traffic analysis

---

## 🧰 Technology Stack

![OpenVPN](https://img.shields.io/badge/OpenVPN-FF6B6B?style=for-the-badge&logo=openvpn&logoColor=white)
![Easy-RSA](https://img.shields.io/badge/Easy--RSA-PKI%20Management-FF9800?style=for-the-badge&logoColor=white)
![Wireshark](https://img.shields.io/badge/Wireshark%20%7C%20tshark-1679A7?style=for-the-badge&logo=wireshark&logoColor=white)
![curl](https://img.shields.io/badge/curl-TLS%20Testing-2196F3?style=for-the-badge&logo=curl&logoColor=white)
![AES](https://img.shields.io/badge/AES--256--GCM-Encryption-4CAF50?style=for-the-badge&logoColor=white)
![iptables](https://img.shields.io/badge/iptables%20%7C%20UFW-Firewall-607D8B?style=for-the-badge&logoColor=white)
![OpenSSL](https://img.shields.io/badge/OpenSSL-Certificates-9C27B0?style=for-the-badge&logo=openssl&logoColor=white)
![Linux](https://img.shields.io/badge/Ubuntu-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

---

<div align="center">

**Built for the Al Nafi Cybersecurity Lab Program**  
*This hands-on experience provides practical skills in VPN deployment and TLS security testing essential for network security professionals.*

</div>
