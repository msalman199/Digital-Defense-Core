#!/bin/bash

echo "=== COLLECTING INCIDENT EVIDENCE ==="
EVIDENCE_DIR="incident_evidence_$(date +%Y%m%d_%H%M%S)"
mkdir -p $EVIDENCE_DIR

# Copy all log files
echo "Collecting system logs..."
sudo cp /var/log/syslog $EVIDENCE_DIR/ 2>/dev/null || echo "Syslog not available"
sudo cp /var/log/auth.log $EVIDENCE_DIR/ 2>/dev/null || echo "Auth log not available"

# Collect network evidence
echo "Collecting network evidence..."
cp suspicious_traffic.pcap $EVIDENCE_DIR/ 2>/dev/null
cp initial_assessment.txt $EVIDENCE_DIR/
cp incident_detection.txt $EVIDENCE_DIR/
cp containment_verification.txt $EVIDENCE_DIR/
cp segmentation_config.txt $EVIDENCE_DIR/

# Create system state snapshot
echo "Creating system state snapshot..."
echo "=== SYSTEM STATE AT EVIDENCE COLLECTION ===" > $EVIDENCE_DIR/system_state.txt
echo "Collection Time: $(date)" >> $EVIDENCE_DIR/system_state.txt
echo "" >> $EVIDENCE_DIR/system_state.txt

echo "Active Processes:" >> $EVIDENCE_DIR/system_state.txt
ps aux >> $EVIDENCE_DIR/system_state.txt
echo "" >> $EVIDENCE_DIR/system_state.txt

echo "Network Connections:" >> $EVIDENCE_DIR/system_state.txt
ss -tuln >> $EVIDENCE_DIR/system_state.txt
echo "" >> $EVIDENCE_DIR/system_state.txt

echo "Firewall Rules:" >> $EVIDENCE_DIR/system_state.txt
sudo iptables -L -n -v >> $EVIDENCE_DIR/system_state.txt

echo "Evidence collected in directory: $EVIDENCE_DIR"
echo $EVIDENCE_DIR > evidence_dir.txt
