# 🛡️ Container Security Essentials 

<div align="center">

# 🚀 Secure Docker Containers Like a Professional

![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-Vulnerability%20Scanner-1904DA?style=for-the-badge)
![Falco](https://img.shields.io/badge/Falco-Runtime%20Security-00ADEF?style=for-the-badge)
![AppArmor](https://img.shields.io/badge/AppArmor-Security%20Profiles-4EAA25?style=for-the-badge)
![DevSecOps](https://img.shields.io/badge/DevSecOps-Container%20Security-red?style=for-the-badge)

### 🔐 Hands-On Container Security & Docker Hardening Lab

</div>

---

# 📚 Lab Overview

Container security is a critical component of modern cloud-native environments. In this lab, you will learn how to identify vulnerabilities, secure Docker containers, implement runtime protections, monitor suspicious activities, and establish security baselines.

---

# 🎯 Objectives

By the end of this lab, you will be able to:

✅ Understand container security concepts and threats

✅ Scan Docker images for vulnerabilities

✅ Configure Docker User Namespace Remapping

✅ Implement Runtime Security Controls

✅ Apply AppArmor Security Profiles

✅ Configure Resource Limits

✅ Secure Container Networking

✅ Deploy Falco Runtime Monitoring

✅ Perform Compliance Scanning

✅ Create Security Baselines

✅ Test Container Breakout Protection

---

# 📋 Prerequisites

Before starting:

- Linux Command Line Basics
- Docker Fundamentals
- Linux User & Permission Management
- Network Security Fundamentals

---

# 🖥️ Lab Environment

Al Nafi Cloud Lab Environment includes:

| Component | Version |
|------------|---------|
| OS | Ubuntu 20.04+ |
| Docker Engine | Preinstalled |
| Security Tools | Included |
| Vulnerable Images | Included |

---

# 🔍 Task 1: Docker Image Vulnerability Scanning

---

## 🛠️ Subtask 1.1 Install Trivy Scanner

### Update System

```bash
sudo apt update && sudo apt upgrade -y
```

### Install Required Packages

```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
```

### Add Trivy Repository

```bash
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -

echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
```

### Install Trivy

```bash
sudo apt-get update

sudo apt-get install trivy -y
```

### Verify Installation

```bash
trivy version
```

---

## 🐳 Subtask 1.2 Pull Sample Images

```bash
docker pull nginx:1.18

docker pull node:14-alpine

docker pull python:3.8-slim
```

### Scan Nginx Image

```bash
trivy image nginx:1.18
```

### Scan Critical Vulnerabilities

```bash
trivy image --severity HIGH,CRITICAL nginx:1.18
```

### Generate JSON Report

```bash
trivy image --format json --output nginx-scan-results.json nginx:1.18
```

### Analyze Report

```bash
cat nginx-scan-results.json | jq '.Results[0].Vulnerabilities | length'
```

---

## 📊 Subtask 1.3 Compare Scan Results

### Scan Node.js Image

```bash
trivy image --severity HIGH,CRITICAL node:14-alpine
```

### Save Comparison Report

```bash
trivy image --format table --output scan-comparison.txt node:14-alpine

cat scan-comparison.txt
```

### Scan Only OS Vulnerabilities

```bash
trivy image --vuln-type os python:3.8-slim
```

---

## ⚙️ Subtask 1.4 CI/CD Security Scanning Script

Create:

```bash
cat > container-security-scan.sh << 'EOF'
#!/bin/bash

IMAGE_NAME=$1
SEVERITY_THRESHOLD="HIGH,CRITICAL"

if [ -z "$IMAGE_NAME" ]; then
    echo "Usage: $0 <image_name>"
    exit 1
fi

echo "Scanning image: $IMAGE_NAME"

trivy image --severity $SEVERITY_THRESHOLD \
--format json \
--output scan-results.json \
$IMAGE_NAME

CRITICAL_COUNT=$(cat scan-results.json | jq '[.Results[]?.Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length')

HIGH_COUNT=$(cat scan-results.json | jq '[.Results[]?.Vulnerabilities[]? | select(.Severity=="HIGH")] | length')

echo "Critical vulnerabilities: $CRITICAL_COUNT"
echo "High vulnerabilities: $HIGH_COUNT"

if [ "$CRITICAL_COUNT" -gt 0 ]; then
    echo "FAIL"
    exit 1
elif [ "$HIGH_COUNT" -gt 5 ]; then
    echo "WARNING"
    exit 1
else
    echo "PASS"
fi
EOF
```

### Make Executable

```bash
chmod +x container-security-scan.sh
```

### Test Script

```bash
./container-security-scan.sh nginx:1.18
```

---

# 🔐 Task 2: Docker Security Features

---

## 👤 Subtask 2.1 Configure User Namespaces

### Check Existing Configuration

```bash
docker info | grep -i "user namespace"
```

### Stop Docker

```bash
sudo systemctl stop docker
```

### Create Docker Configuration

```bash
sudo mkdir -p /etc/docker
```

```bash
cat > /tmp/daemon.json << 'EOF'
{
  "userns-remap":"default",
  "storage-driver":"overlay2",
  "log-driver":"json-file",
  "log-opts":{
     "max-size":"10m",
     "max-file":"3"
  }
}
EOF
```

### Apply Configuration

```bash
sudo cp /tmp/daemon.json /etc/docker/daemon.json
```

### Create Namespace User

```bash
sudo useradd -r -s /bin/false dockremap
```

```bash
echo 'dockremap:165536:65536' | sudo tee -a /etc/subuid

echo 'dockremap:165536:65536' | sudo tee -a /etc/subgid
```

### Restart Docker

```bash
sudo systemctl start docker

sudo systemctl status docker
```

### Verify

```bash
docker info | grep -i "user namespace"
```

---

## 🛡️ Subtask 2.2 Runtime Security Controls

### Launch Secure Container

```bash
docker run -d --name secure-nginx \
--user 1000:1000 \
--cap-drop ALL \
--cap-add NET_BIND_SERVICE \
--read-only \
--tmpfs /tmp \
--tmpfs /var/cache/nginx \
--tmpfs /var/run \
-p 8080:80 \
nginx:alpine
```

### Verify User

```bash
docker exec secure-nginx whoami

docker exec secure-nginx id
```

### Test Read-Only Filesystem

```bash
docker exec secure-nginx touch /test-file
```

Expected: ❌ Permission Denied

---

## 🔒 Subtask 2.3 Configure AppArmor Profile

```bash
sudo mkdir -p /etc/apparmor.d/containers
```

Create custom profile and load:

```bash
sudo apparmor_parser -r -W /etc/apparmor.d/containers/docker-nginx
```

### Run Protected Container

```bash
docker run -d \
--name apparmor-nginx \
--security-opt apparmor=docker-nginx \
-p 8081:80 \
nginx:alpine
```

---

## 📈 Subtask 2.4 Resource Constraints

### Deploy Resource Limited Container

```bash
docker run -d \
--name resource-limited \
--memory=128m \
--memory-swap=128m \
--cpus="0.5" \
--pids-limit=100 \
--ulimit nofile=1024:1024 \
--restart=unless-stopped \
nginx:alpine
```

### Monitor Resources

```bash
docker stats resource-limited --no-stream
```

### Test Memory Limit

```bash
docker exec resource-limited \
sh -c 'dd if=/dev/zero of=/tmp/test bs=1M count=200'
```

---

## 🌐 Subtask 2.5 Secure Network Configuration

### Create Secure Network

```bash
docker network create \
--driver bridge \
--subnet=172.20.0.0/16 \
--ip-range=172.20.240.0/20 \
--gateway=172.20.0.1 \
secure-network
```

### Launch Containers

```bash
docker run -d \
--name web-server \
--network secure-network \
--ip 172.20.240.10 \
nginx:alpine
```

```bash
docker run -d \
--name app-server \
--network secure-network \
--ip 172.20.240.11 \
python:3.8-alpine sleep 3600
```

### Connectivity Testing

```bash
docker exec web-server ping -c 3 172.20.240.11

docker exec app-server ping -c 3 172.20.240.10
```

---

# 📡 Task 3: Runtime Monitoring & Compliance

---

## 🚨 Subtask 3.1 Install Falco

### Install Falco

```bash
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | sudo apt-key add -

echo "deb https://download.falco.org/packages/deb stable main" | sudo tee -a /etc/apt/sources.list.d/falcosecurity.list

sudo apt-get update -y

sudo apt-get install -y falco
```

### Start Monitoring

```bash
sudo systemctl start falco

sudo systemctl enable falco
```

### Watch Alerts

```bash
sudo tail -f /var/log/falco.log
```

---

## 📋 Subtask 3.2 Docker Bench Security

### Clone Tool

```bash
git clone https://github.com/docker/docker-bench-security.git

cd docker-bench-security
```

### Run Assessment

```bash
sudo ./docker-bench-security.sh
```

### Export Results

```bash
sudo ./docker-bench-security.sh -l /tmp/docker-bench-results.log

cat /tmp/docker-bench-results.log
```

---

## 🏗️ Subtask 3.3 Security Baseline

Create baseline script:

```bash
cat > docker-security-baseline.sh << 'EOF'
#!/bin/bash

echo "Applying Docker Security Baseline..."
EOF
```

Make executable:

```bash
chmod +x docker-security-baseline.sh

./docker-security-baseline.sh
```

---

# 🧪 Task 4: Practical Security Testing

---

## 🔓 Subtask 4.1 Container Breakout Testing

### Launch Secure Test Container

```bash
docker run -it --rm \
--cap-drop ALL \
--cap-add NET_BIND_SERVICE \
--user 1000:1000 \
--read-only \
--tmpfs /tmp \
ubuntu:20.04 bash
```

### Attempt Escape

```bash
ls /host

cat /proc/version

sudo su -

touch /test-file
```

Expected Results:

| Test | Expected |
|--------|----------|
| Host Access | ❌ Denied |
| Privilege Escalation | ❌ Blocked |
| File Creation | ❌ Blocked |

---

## 🔄 Subtask 4.2 Vulnerability Response Workflow

Create:

```bash
cat > vulnerability-response.sh << 'EOF'
#!/bin/bash

CONTAINER_NAME=$1
SEVERITY_THRESHOLD="HIGH"

echo "Container Security Response Workflow"
EOF
```

### Make Executable

```bash
chmod +x vulnerability-response.sh
```

### Execute

```bash
./vulnerability-response.sh secure-nginx
```

---

# ✅ Verification

## User Namespace Check

```bash
docker info | grep -i "user namespace"
```

## Active Containers

```bash
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
```

## Networks

```bash
docker network ls
```

## Docker Bench Runtime Scan

```bash
docker run --rm \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
-v /tmp:/tmp \
docker/docker-bench-security
```

---

# 🛠️ Troubleshooting

## User Namespace Issues

```bash
cat /proc/sys/user/max_user_namespaces

cat /etc/subuid

cat /etc/subgid
```

---

## Trivy Scan Issues

```bash
trivy image --download-db-only

trivy clean --all

trivy image nginx:latest
```

---

## Runtime Security Problems

```bash
sudo aa-status

grep CONFIG_SECCOMP /boot/config-$(uname -r)

docker run --rm \
--security-opt seccomp=unconfined \
ubuntu:20.04 echo "test"
```

---

# 🧹 Cleanup

### Remove Containers

```bash
docker stop $(docker ps -aq) 2>/dev/null

docker rm $(docker ps -aq) 2>/dev/null
```

### Remove Network

```bash
docker network rm secure-network
```

### Remove Unused Images

```bash
docker image prune -f
```

### Remove Temporary Files

```bash
rm -f *.json *.txt *.sh \
vuln-report.json \
scan-results.json
```

---

# 🎓 Conclusion

You successfully implemented:

✅ Container Vulnerability Scanning

✅ Docker User Namespace Remapping

✅ Runtime Security Controls

✅ AppArmor Security Profiles

✅ Resource Constraints

✅ Network Isolation

✅ Falco Monitoring

✅ Compliance Scanning

✅ Security Baselines

✅ Breakout Prevention Testing

---

# 💡 Key Security Principles Learned

### 🛡️ Defense in Depth

Multiple security layers reduce attack success.

### 🔎 Continuous Vulnerability Scanning

Identify threats before deployment.

### 🔐 Least Privilege

Containers receive only required permissions.

### 🚨 Runtime Monitoring

Detect malicious activity immediately.

### 📜 Compliance & Hardening

Maintain secure configurations consistently.

---

<div align="center">

# 🎉 Congratulations!

You have completed the

## 🛡️ Container Security Essentials Lab

### Ready for DevSecOps • Cloud Security • Container Security Engineering

⭐ Happy Securing Containers! ⭐

</div>
