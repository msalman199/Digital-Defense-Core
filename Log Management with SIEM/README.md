# 📊 Log Management with SIEM Tools

<div align="center">

# 🛡️ Centralized Log Management & Security Monitoring with ELK Stack

![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04_LTS-E95420?style=for-the-badge\&logo=ubuntu\&logoColor=white)
![Elasticsearch](https://img.shields.io/badge/Elasticsearch-7.x-005571?style=for-the-badge\&logo=elasticsearch\&logoColor=white)
![Logstash](https://img.shields.io/badge/Logstash-Data_Pipeline-FEC514?style=for-the-badge\&logo=elastic\&logoColor=black)
![Kibana](https://img.shields.io/badge/Kibana-Visualization-005571?style=for-the-badge\&logo=kibana\&logoColor=white)
![SIEM](https://img.shields.io/badge/SIEM-Security_Monitoring-red?style=for-the-badge)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge\&logo=gnubash\&logoColor=white)

### 🔍 Build a Centralized Security Monitoring Platform Using the ELK Stack

</div>

---

# 📚 Overview

Security Information and Event Management (SIEM) systems provide centralized log collection, analysis, monitoring, and threat detection.

In this lab you will:

* Install and configure the ELK Stack
* Centralize system and application logs
* Normalize logs using Logstash
* Create custom threat detection scripts
* Configure log rotation and retention
* Build security dashboards in Kibana
* Validate end-to-end log ingestion

---

# 🎯 Lab Objectives

By the end of this lab, you will be able to:

✅ Install Elasticsearch

✅ Configure Logstash Pipelines

✅ Deploy Kibana Dashboards

✅ Create Log Analysis Scripts

✅ Implement Threat Detection Logic

✅ Configure Log Rotation

✅ Normalize Logs into JSON Format

✅ Build Security Monitoring Visualizations

✅ Understand SIEM Fundamentals

---

# 📋 Prerequisites

Before starting this lab:

* Linux Command Line Proficiency
* Understanding of System Logs
* Basic Bash Scripting
* Familiarity with Networking
* Knowledge of Security Monitoring Concepts

---

# 🖥️ Lab Environment

### Al Nafi Cloud Environment

| Component    | Specification    |
| ------------ | ---------------- |
| OS           | Ubuntu 20.04 LTS |
| RAM          | 4GB Minimum      |
| Storage      | 20GB             |
| Internet     | Enabled          |
| Dependencies | Pre-installed    |

---

# 🚀 Task 1: Installing and Configuring the ELK Stack

---

# 🔧 Step 1.1 System Preparation

## Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
```

## Install Java 11

```bash
sudo apt install openjdk-11-jdk -y
```

## Verify Installation

```bash
java -version
```

Expected Output:

```text
openjdk version "11.x.x"
```

---

# 🔍 Step 1.2 Install Elasticsearch

## Add Elastic Repository

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
```

## Install Elasticsearch

```bash
sudo apt update

sudo apt install elasticsearch -y
```

## Configure Elasticsearch

Edit:

```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Add:

```yaml
network.host: localhost
http.port: 9200
discovery.type: single-node
xpack.security.enabled: false
```

## Start Service

```bash
sudo systemctl start elasticsearch

sudo systemctl enable elasticsearch
```

## Verify

```bash
sleep 30

curl -X GET "localhost:9200/"
```

---

# 📥 Step 1.3 Install Logstash

## Install

```bash
sudo apt install logstash -y
```

## Create Pipeline Configuration

```bash
sudo nano /etc/logstash/conf.d/siem-pipeline.conf
```

Configuration:

```ruby
input {
  file {
    path => "/var/log/auth.log"
    start_position => "beginning"
    type => "auth"
  }
}

filter {
  if [type] == "auth" {
    grok {
      match => {
        "message" =>
        "%{SYSLOGTIMESTAMP:timestamp} %{IPORHOST:host} %{PROG:program}: %{GREEDYDATA:message_body}"
      }
    }
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "siem-logs-%{+YYYY.MM.dd}"
  }
}
```

## Start Logstash

```bash
sudo systemctl start logstash

sudo systemctl enable logstash
```

---

# 📊 Step 1.4 Install Kibana

## Install

```bash
sudo apt install kibana -y
```

## Configure

```bash
sudo nano /etc/kibana/kibana.yml
```

Add:

```yaml
server.port: 5601
server.host: "localhost"
elasticsearch.hosts: ["http://localhost:9200"]
```

## Start Kibana

```bash
sudo systemctl start kibana

sudo systemctl enable kibana
```

## Verify

```bash
sleep 60

curl -I http://localhost:5601
```

---

# 🌐 Step 1.5 Install Apache for Log Generation

## Install Apache

```bash
sudo apt install apache2 -y

sudo systemctl start apache2
```

## Generate Sample Traffic

```bash
curl http://localhost/

curl http://localhost/test-page
```

---

# 🔍 Task 2: Creating Log Analysis Scripts

---

# 🔐 Step 2.1 Authentication Log Analyzer

## Create Project Directory

```bash
mkdir ~/siem-scripts

cd ~/siem-scripts
```

## Create Analyzer Script

```bash
nano auth-analyzer.sh
```

Features to Implement:

### Failed Login Analysis

* Extract failed logins
* Count source IPs
* Rank by frequency

### Brute Force Detection

* Detect >5 failures
* Generate alerts
* Record usernames

### Sudo Activity Analysis

* Identify privilege escalation
* Record executed commands

Make Executable:

```bash
chmod +x auth-analyzer.sh
```

---

# 🌍 Step 2.2 Web Log Analyzer

Create:

```bash
nano web-analyzer.sh
```

Features:

### Top Source IPs

* Count visitors
* Display Top 20

### HTTP Status Analysis

* 200 Responses
* 404 Responses
* 500 Errors

### Web Attack Detection

Search for:

* SQL Injection
* Directory Traversal
* Excessive 404 Activity

Make Executable:

```bash
chmod +x web-analyzer.sh
```

---

# 🚨 Step 2.3 Real-Time Security Monitor

Create:

```bash
nano realtime-monitor.sh
```

Capabilities:

### Authentication Monitoring

Detect:

* Failed Logins
* Successful Logins
* Sudo Usage

### Web Monitoring

Detect:

* 404 Flooding
* Attack Payloads
* Suspicious Requests

### Alerting

Format:

```text
[TIMESTAMP] ALERT: TYPE - MESSAGE
```

Make Executable:

```bash
chmod +x realtime-monitor.sh
```

---

# 📦 Task 3: Log Retention & Normalization

---

# 🔄 Step 3.1 Configure Log Rotation

Create:

```bash
sudo nano /etc/logrotate.d/siem-logs
```

Authentication Logs:

```conf
/var/log/auth.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 640 syslog adm
}
```

Apache Logs:

```conf
/var/log/apache2/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 640 root adm
    sharedscripts

    postrotate
        systemctl reload apache2
    endscript
}
```

Test:

```bash
sudo logrotate -d /etc/logrotate.d/siem-logs
```

Force Rotation:

```bash
sudo logrotate -f /etc/logrotate.d/siem-logs
```

---

# 🧩 Step 3.2 Log Normalization

Create:

```bash
nano log-normalizer.sh
```

Convert Logs to JSON:

### Authentication Events

```json
{
  "timestamp":"2025-01-01",
  "event_type":"auth_failure",
  "user":"admin",
  "source_ip":"192.168.1.100",
  "severity":"high"
}
```

### Web Events

```json
{
  "timestamp":"2025-01-01",
  "source_ip":"192.168.1.50",
  "method":"GET",
  "url":"/admin",
  "status_code":"404"
}
```

Make Executable:

```bash
chmod +x log-normalizer.sh
```

---

# 📈 Task 4: Kibana Dashboard Setup

---

# 🗂️ Step 4.1 Create Index Pattern

```bash
curl -X POST \
"http://localhost:5601/api/saved_objects/index-pattern/siem-logs-*" \
-H "Content-Type: application/json" \
-H "kbn-xsrf: true" \
-d '{
  "attributes": {
    "title":"siem-logs-*",
    "timeFieldName":"@timestamp"
  }
}'
```

---

# 📊 Step 4.2 Dashboard Configuration

Create:

```bash
nano setup-dashboard.sh
```

Dashboard Components:

### Pie Chart

* Log Types Distribution

### Bar Chart

* Top Source IPs

### Line Graph

* Events Over Time

### Data Table

* Recent Alerts

Make Executable:

```bash
chmod +x setup-dashboard.sh
```

---

# 🧪 Task 5: Testing & Validation

---

# 🔥 Step 5.1 Generate Test Data

Create:

```bash
nano generate-test-data.sh
```

Script Activities:

### Failed Logins

```text
5 Failed SSH Attempts
```

### Successful Login

```text
Accepted password for admin
```

### Sudo Activity

```text
Privilege Escalation Event
```

### Web Traffic

```text
Normal Requests
Admin Requests
SQL Injection Simulation
```

Run:

```bash
chmod +x generate-test-data.sh

./generate-test-data.sh
```

---

# ✅ Step 5.2 SIEM Validation

Create:

```bash
nano validate-siem.sh
```

Validation Checks:

### Elasticsearch

* Cluster Health
* Node Availability

### Logstash

* Service Status
* Pipeline Health

### Kibana

* UI Availability
* API Access

### Log Indexing

* Verify Document Count
* Confirm Data Ingestion

Run:

```bash
chmod +x validate-siem.sh

./validate-siem.sh
```

---

# 🎯 Expected Outcomes

After completion:

✅ Functional ELK Stack

✅ Centralized Log Collection

✅ Custom Analysis Scripts

✅ Real-Time Monitoring

✅ Log Retention Policies

✅ JSON Normalization Pipeline

✅ Security Dashboards

✅ Threat Detection Workflows

---

# 🛠️ Troubleshooting Guide

---

## Issue 1: Elasticsearch Won't Start

Verify Java:

```bash
java -version
```

Check Logs:

```bash
sudo journalctl -u elasticsearch -f
```

---

## Issue 2: Logstash Not Processing Logs

Validate Configuration:

```bash
sudo /usr/share/logstash/bin/logstash \
--config.test_and_exit \
-f /etc/logstash/conf.d/siem-pipeline.conf
```

View Logs:

```bash
sudo journalctl -u logstash -f
```

---

## Issue 3: Kibana Not Accessible

Check Status:

```bash
sudo journalctl -u kibana -f
```

Verify Port:

```bash
sudo ss -tulpn | grep 5601
```

---

## Issue 4: No Logs in Elasticsearch

List Indices:

```bash
curl -X GET "localhost:9200/_cat/indices?v"
```

Generate Additional Test Data

Wait 1–2 Minutes

Recheck Index Count

---

# 📚 Key Concepts Summary

### 📊 SIEM

Centralized Security Monitoring Platform

### 🔍 Elasticsearch

Log Storage & Search Engine

### 🔄 Logstash

Data Processing & Normalization

### 📈 Kibana

Visualization & Dashboard Platform

### 🛡️ Threat Detection

Identifying Suspicious Security Events

### 📦 Log Retention

Managing Long-Term Log Storage

---

# 🎓 Conclusion

Congratulations! 🎉

You successfully built a complete ELK-based SIEM environment.

---

# 🏆 Key Achievements

### 🔍 Log Collection

* Centralized Authentication Logs
* Web Server Logs
* Security Events

### 🧩 Data Processing

* Parsing
* Normalization
* Enrichment

### 📈 Visualization

* Dashboards
* Charts
* Security Monitoring

### 🚨 Detection

* Brute Force Attempts
* Suspicious Activity
* Web Attack Indicators

### 🔄 Retention

* Log Rotation
* Archiving
* Storage Management

---

# 🌍 Real-World Relevance

These skills are used by:

* SOC Analysts
* Security Engineers
* Incident Responders
* Threat Hunters
* SIEM Administrators
* Blue Team Professionals

---

# 🚀 Next Learning Path

* Advanced ELK Stack
* Threat Hunting
* Detection Engineering
* Sigma Rules
* SIEM Correlation Rules
* DFIR
* Security Operations Center (SOC)

---

<div align="center">

# 🎉 Congratulations!

## 📊 Log Management with SIEM Tools Lab Completed

### Ready for SOC • SIEM • Threat Hunting • Detection Engineering

⭐ Collect • Analyze • Detect • Respond ⭐

</div>
