#!/bin/bash

IMAGE_NAME=$1
SEVERITY_THRESHOLD="HIGH,CRITICAL"

if [ -z "$IMAGE_NAME" ]; then
    echo "Usage: $0 <image_name>"
    exit 1
fi

echo "Scanning image: $IMAGE_NAME"
echo "Severity threshold: $SEVERITY_THRESHOLD"

# Perform the scan
trivy image --severity $SEVERITY_THRESHOLD --format json --output scan-results.json $IMAGE_NAME

# Check if critical vulnerabilities exist
CRITICAL_COUNT=$(cat scan-results.json | jq '[.Results[]?.Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length')
HIGH_COUNT=$(cat scan-results.json | jq '[.Results[]?.Vulnerabilities[]? | select(.Severity=="HIGH")] | length')

echo "Critical vulnerabilities found: $CRITICAL_COUNT"
echo "High severity vulnerabilities found: $HIGH_COUNT"

if [ "$CRITICAL_COUNT" -gt 0 ]; then
    echo "FAIL: Critical vulnerabilities detected. Deployment blocked."
    exit 1
elif [ "$HIGH_COUNT" -gt 5 ]; then
    echo "WARNING: High number of high-severity vulnerabilities detected."
    exit 1
else
    echo "PASS: Image security scan completed successfully."
    exit 0
fi
