# 🔍 Digital Forensics with Autopsy 

<div align="center">

# 🛡️ Digital Evidence Investigation & Forensic Analysis

![Linux](https://img.shields.io/badge/Linux-Ubuntu_22.04-E95420?style=for-the-badge\&logo=ubuntu\&logoColor=white)
![Autopsy](https://img.shields.io/badge/Autopsy-4.20+-blue?style=for-the-badge)
![SleuthKit](https://img.shields.io/badge/SleuthKit-Forensics-green?style=for-the-badge)
![Digital Forensics](https://img.shields.io/badge/Digital-Forensics-red?style=for-the-badge)
![Incident Response](https://img.shields.io/badge/Incident-Response-orange?style=for-the-badge)
![Cybersecurity](https://img.shields.io/badge/Cybersecurity-Investigation-purple?style=for-the-badge)

### 🔬 Hands-On Digital Forensics Investigation Using Autopsy & SleuthKit

</div>

---

# 📚 Lab Overview

Digital Forensics is the process of collecting, preserving, analyzing, and documenting digital evidence in a legally admissible manner.

In this lab, you will learn how to:

* Create forensic disk images
* Preserve evidence integrity using cryptographic hashes
* Analyze file systems using Autopsy
* Recover deleted files
* Investigate hidden files and metadata
* Generate forensic timelines
* Produce professional forensic reports

---

# 🎯 Objectives

By the end of this lab, you will be able to:

✅ Install and Configure Autopsy

✅ Create and Analyze Disk Images

✅ Preserve Evidence Integrity

✅ Recover Deleted Files

✅ Examine File System Artifacts

✅ Conduct Timeline Analysis

✅ Analyze Metadata

✅ Generate Forensic Reports

✅ Understand Chain of Custody

---

# 📋 Prerequisites

Before starting:

* Linux Command Line Basics
* Understanding of File Systems (FAT32, NTFS, ext4)
* Basic Storage Concepts
* File Metadata Knowledge

No prior forensic experience required.

---

# 🖥️ Lab Environment

### Al Nafi Cloud Environment

| Component        | Version               |
| ---------------- | --------------------- |
| Operating System | Ubuntu 22.04 LTS      |
| Autopsy          | 4.20+                 |
| SleuthKit        | Included              |
| Sample Evidence  | Included              |
| Privileges       | Administrative Access |

---

# 🔐 Task 1: Setting Up Autopsy & Creating Evidence

---

## 🛠️ Subtask 1.1 Verify Installation

### Check Autopsy Installation

```bash
autopsy --version
```

### Install If Required

```bash
sudo apt update

sudo apt install autopsy sleuthkit -y
```

### Verify Installation Path

```bash
which autopsy
```

---

## 💾 Subtask 1.2 Create Sample Evidence Image

### Create Working Directory

```bash
mkdir -p ~/forensics_lab

cd ~/forensics_lab
```

### Create Disk Image

```bash
dd if=/dev/zero of=evidence_usb.img bs=1M count=100
```

### Attach Loop Device

```bash
sudo losetup /dev/loop0 evidence_usb.img
```

### Format FAT32

```bash
sudo mkfs.fat -F 32 /dev/loop0
```

### Create Mount Point

```bash
mkdir -p ~/forensics_lab/mount_point

sudo mount /dev/loop0 ~/forensics_lab/mount_point
```

---

## 📁 Create Evidence Files

### Create Directories

```bash
sudo mkdir ~/forensics_lab/mount_point/Documents

sudo mkdir ~/forensics_lab/mount_point/Pictures

sudo mkdir ~/forensics_lab/mount_point/System
```

### Create Confidential Documents

```bash
echo "This is a confidential document created on $(date)" | sudo tee ~/forensics_lab/mount_point/Documents/confidential.txt

echo "Meeting notes: Project Alpha discussion" | sudo tee ~/forensics_lab/mount_point/Documents/meeting_notes.txt

echo "Password list: admin123, user456, guest789" | sudo tee ~/forensics_lab/mount_point/Documents/passwords.txt
```

### Create Hidden File

```bash
echo "Hidden system configuration data" | sudo tee ~/forensics_lab/mount_point/.hidden_config
```

### Create Image Files

```bash
echo "JPEG image data would be here" | sudo tee ~/forensics_lab/mount_point/Pictures/photo1.jpg

echo "PNG image data would be here" | sudo tee ~/forensics_lab/mount_point/Pictures/screenshot.png
```

### Create System Log

```bash
echo "System log entry: User login at $(date)" | sudo tee ~/forensics_lab/mount_point/System/system.log
```

---

## 🗑️ Create Deleted Evidence

### Create File

```bash
echo "This file will be deleted for forensic recovery" | sudo tee ~/forensics_lab/mount_point/deleted_file.txt
```

### Delete File

```bash
sudo rm ~/forensics_lab/mount_point/deleted_file.txt
```

---

## 📦 Finalize Evidence

```bash
sudo umount ~/forensics_lab/mount_point

sudo losetup -d /dev/loop0
```

### Verify Evidence

```bash
ls -la ~/forensics_lab/evidence_usb.img
```

---

## 🔑 Subtask 1.3 Calculate Hash Values

### Generate MD5 Hash

```bash
md5sum evidence_usb.img > evidence_usb.img.md5
```

### Generate SHA256 Hash

```bash
sha256sum evidence_usb.img > evidence_usb.img.sha256
```

### View Hashes

```bash
cat evidence_usb.img.md5

cat evidence_usb.img.sha256
```

---

# 🚀 Task 2: Extract Evidence Using Autopsy

---

## 🌐 Subtask 2.1 Start Autopsy

### Launch Autopsy

```bash
cd ~/forensics_lab

autopsy &
```

### Wait For Startup

```bash
sleep 5
```

### Access Web Interface

```text
http://localhost:9999/autopsy
```

### Open Browser

```bash
firefox http://localhost:9999/autopsy &
```

or

```bash
chromium-browser http://localhost:9999/autopsy &
```

---

## 📂 Subtask 2.2 Create New Case

### Case Information

| Setting      | Value                           |
| ------------ | ------------------------------- |
| Case Name    | USB_Investigation_2024          |
| Description  | Forensic Analysis of USB Device |
| Investigator | Your Name                       |

---

### Host Information

| Setting     | Value               |
| ----------- | ------------------- |
| Host Name   | EVIDENCE_USB        |
| Description | USB Evidence Device |
| Time Zone   | Local Timezone      |

---

## 💿 Subtask 2.3 Add Evidence Image

### Evidence Details

| Option        | Value            |
| ------------- | ---------------- |
| Image Type    | Disk             |
| Import Method | Copy             |
| Image Path    | evidence_usb.img |

### Enable Analysis Modules

✅ File System Analysis

✅ Hash Analysis

✅ Keyword Search

✅ Timeline Analysis

---

## 📈 Subtask 2.4 Monitor Analysis

### Check Running Process

```bash
top -p $(pgrep -f autopsy) -n 1
```

### Expected Analysis Time

```text
2–5 Minutes
```

---

# 🔍 Task 3: Analyze File System Artifacts

---

## 📁 Subtask 3.1 Examine File Structure

### Investigate Directories

```text
/Documents/
/Pictures/
/System/
```

### Review File Metadata

For:

```text
confidential.txt
```

Document:

* File Size
* Created Time
* Modified Time
* Access Time
* Permissions

---

## 🕵️ Subtask 3.2 Hidden & Deleted Files

### Locate Hidden Files

Search for:

```text
.hidden_config
```

### Recover Deleted File

Search for:

```text
deleted_file.txt
```

### Keyword Searches

Use keywords:

```text
password
confidential
admin
```

Review all findings.

---

## ⏰ Subtask 3.3 Timeline Analysis

### Generate Timeline Body File

```bash
fls -r -m / evidence_usb.img > timeline_body.txt
```

### Create Readable Timeline

```bash
mactime -b timeline_body.txt -d > filesystem_timeline.txt
```

### Review Timeline

```bash
head -20 filesystem_timeline.txt
```

---

### Timeline Investigation Goals

✅ File Creation Events

✅ File Modification Events

✅ Deleted File Activity

✅ Suspicious Time Gaps

---

## 🔎 Subtask 3.4 Hash & Metadata Analysis

### Review Hash Values

Inside Autopsy:

```text
Hash Analysis Tab
```

### Examine File Types

```text
Documents
Images
System Files
Unknown Files
```

### Extract Metadata

Analyze:

```text
photo1.jpg
screenshot.png
```

Document available metadata.

---

# 📄 Task 4: Investigation Documentation

---

## 📝 Subtask 4.1 Investigation Report

### Create Report

```bash
cd ~/forensics_lab

nano investigation_report.txt
```

### Include

* Case Information
* Evidence Information
* Hash Values
* Timeline Findings
* Deleted File Recovery
* Metadata Findings
* Conclusions
* Chain of Custody

---

## 📦 Subtask 4.2 Export Evidence

### Export Important Files

Export:

```text
confidential.txt
passwords.txt
meeting_notes.txt
.hidden_config
```

Save to:

```bash
~/forensics_lab/exported_evidence
```

---

## 📊 Generate Autopsy Report

### Report Settings

| Option  | Value       |
| ------- | ----------- |
| Format  | HTML        |
| Include | All Modules |

Generate comprehensive report.

---

## 🔐 Subtask 4.3 Verify Integrity

### Recalculate Hashes

```bash
md5sum evidence_usb.img > final_check.md5

sha256sum evidence_usb.img > final_check.sha256
```

### Compare Results

```bash
diff evidence_usb.img.md5 final_check.md5

diff evidence_usb.img.sha256 final_check.sha256
```

### Success Result

```text
Evidence Integrity Maintained
```

---

# ✅ Verification & Testing

---

## Verify Autopsy Process

```bash
ps aux | grep autopsy
```

---

## Verify Hash Integrity

```bash
cat evidence_usb.img.md5

cat evidence_usb.img.sha256
```

---

## Verify Timeline

```bash
head -20 filesystem_timeline.txt
```

---

## Verify Deleted File Recovery

Confirm:

```text
deleted_file.txt
```

appears in analysis.

---

# 🛠️ Troubleshooting

---

## Issue 1: Autopsy Not Starting

### Check Port Usage

```bash
netstat -tlnp | grep 9999
```

### Kill Existing Process

```bash
pkill -f autopsy
```

### Restart

```bash
autopsy &
```

---

## Issue 2: Loop Device Problems

### View Devices

```bash
losetup -a
```

### Find Free Device

```bash
sudo losetup -f
```

### Attach Device

```bash
sudo losetup /dev/loopX evidence_usb.img
```

---

## Issue 3: Browser Connection Failure

### Verify Autopsy

```bash
ps aux | grep autopsy
```

### Check Firewall

```bash
sudo ufw status
```

### Test Connectivity

```bash
curl -I http://localhost:9999/autopsy
```

---

# 📚 Key Concepts Summary

### 🔍 Digital Forensics

Scientific investigation of digital evidence.

### 🔐 Chain of Custody

Documentation proving evidence integrity.

### 🧮 Hash Values

Cryptographic fingerprints verifying evidence.

### 📁 File System Artifacts

Metadata, deleted files, hidden files, and logs.

### ⏰ Timeline Analysis

Chronological reconstruction of events.

---

# 🎓 Conclusion

Congratulations! 🎉

You successfully completed a complete Digital Forensics Investigation using Autopsy.

---

# 🏆 Key Achievements

### 🔍 Evidence Acquisition

* Disk Imaging
* Evidence Preservation
* Integrity Verification

### 📂 File System Analysis

* Hidden Files
* Deleted Files
* Metadata Analysis

### ⏰ Timeline Reconstruction

* Event Analysis
* Activity Tracking
* Investigation Correlation

### 📄 Forensic Reporting

* Chain of Custody
* Technical Findings
* Professional Documentation

---

# 🌍 Real-World Relevance

These skills are used by:

* Digital Forensics Analysts
* Incident Responders
* Law Enforcement Agencies
* SOC Teams
* Cybercrime Investigators
* DFIR Specialists

---

# 🚀 Next Learning Path

* Memory Forensics
* Network Forensics
* Malware Analysis
* Threat Hunting
* Incident Response
* DFIR Operations
* Advanced Autopsy Investigations

---

<div align="center">

# 🎉 Congratulations!

## 🔍 Digital Forensics with Autopsy Lab Completed

### Ready for DFIR • Incident Response • Digital Investigations

⭐ Preserve • Analyze • Investigate • Report ⭐

</div>
