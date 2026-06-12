#!/bin/bash

# Firewall testing script

echo "=== Firewall Rule Testing ==="

# Test allowed ports
echo "Testing allowed services..."

# Test SSH (should be allowed)
if nc -z localhost 22 2>/dev/null; then
    echo "✓ SSH (port 22): ACCESSIBLE"
else
    echo "✗ SSH (port 22): BLOCKED"
fi

# Test HTTP (should be allowed)
if nc -z localhost 80 2>/dev/null; then
    echo "✓ HTTP (port 80): ACCESSIBLE"
else
    echo "✗ HTTP (port 80): BLOCKED"
fi

# Test blocked ports
echo ""
echo "Testing blocked services..."

# Test Telnet (should be blocked)
if nc -z localhost 23 2>/dev/null; then
    echo "✗ Telnet (port 23): ACCESSIBLE (SECURITY RISK!)"
else
    echo "✓ Telnet (port 23): BLOCKED"
fi

# Test RPC (should be blocked)
if nc -z localhost 135 2>/dev/null; then
    echo "✗ RPC (port 135): ACCESSIBLE (SECURITY RISK!)"
else
    echo "✓ RPC (port 135): BLOCKED"
fi

echo ""
echo "=== Firewall Status ==="
sudo iptables -L -n | grep -E "ACCEPT|DROP|REJECT" | head -10

echo ""
echo "=== Recent Firewall Logs ==="
tail -5 /var/log/syslog | grep "FIREWALL" || echo "No recent firewall logs found"
