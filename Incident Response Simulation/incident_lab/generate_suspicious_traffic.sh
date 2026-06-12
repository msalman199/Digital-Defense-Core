#!/bin/bash

echo "Generating suspicious network traffic..."

# Simulate port scanning
nmap -sS localhost > /dev/null 2>&1 &

# Create multiple connections to our suspicious server
for i in {1..5}; do
    curl -s http://localhost:8080 > /dev/null &
    sleep 1
done

# Simulate data exfiltration attempt
cat > fake_data.txt << 'DATAEOF'
Confidential Company Data
Employee Records: John Doe, Jane Smith
Financial Information: Q4 Revenue $1.2M
DATAEOF

# Attempt to send data (simulated)
nc -l -p 9999 > /dev/null 2>&1 &
NC_PID=$!
echo $NC_PID > nc_pid.txt

echo "Suspicious traffic generated"
