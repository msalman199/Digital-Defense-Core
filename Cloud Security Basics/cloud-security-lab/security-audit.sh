#!/bin/bash

AUDIT_LOG="/opt/cloud-security-lab/logs/security-audit-$(date +%Y%m%d-%H%M%S).log"
REPORT_FILE="/opt/cloud-security-lab/logs/security-report.html"

# Function to perform system security audit
perform_audit() {
    echo "=== Cloud Security Audit Report - $(date) ===" | tee "$AUDIT_LOG"
    echo "=================================================" | tee -a "$AUDIT_LOG"
    
    # Check system updates
    echo -e "\n1. SYSTEM UPDATE STATUS:" | tee -a "$AUDIT_LOG"
    apt list --upgradable 2>/dev/null | head -10 | tee -a "$AUDIT_LOG"
    
    # Check user accounts
    echo -e "\n2. USER ACCOUNT ANALYSIS:" | tee -a "$AUDIT_LOG"
    echo "Users with shell access:" | tee -a "$AUDIT_LOG"
    grep -E ":/bin/(bash|sh)$" /etc/passwd | tee -a "$AUDIT_LOG"
    
    # Check sudo privileges
    echo -e "\n3. SUDO PRIVILEGES:" | tee -a "$AUDIT_LOG"
    grep -v "^#" /etc/sudoers | grep -v "^$" | tee -a "$AUDIT_LOG"
    
    # Check running services
    echo -e "\n4. RUNNING SERVICES:" | tee -a "$AUDIT_LOG"
    systemctl list-units --type=service --state=running --no-pager | tee -a "$AUDIT_LOG"
    
    # Check open ports
    echo -e "\n5. OPEN NETWORK PORTS:" | tee -a "$AUDIT_LOG"
    netstat -tuln | grep LISTEN | tee -a "$AUDIT_LOG"
    
    # Check firewall status
    echo -e "\n6. FIREWALL STATUS:" | tee -a "$AUDIT_LOG"
    sudo ufw status verbose | tee -a "$AUDIT_LOG"
    
    # Check file permissions on sensitive files
    echo -e "\n7. SENSITIVE FILE PERMISSIONS:" | tee -a "$AUDIT_LOG"
    ls -la /etc/passwd /etc/shadow /etc/sudoers | tee -a "$AUDIT_LOG"
    
    # Check for failed login attempts
    echo -e "\n8. RECENT FAILED LOGIN ATTEMPTS:" | tee -a "$AUDIT_LOG"
    grep "Failed password" /var/log/auth.log | tail -5 | tee -a "$AUDIT_LOG"
    
    # Check disk usage
    echo -e "\n9. DISK USAGE:" | tee -a "$AUDIT_LOG"
    df -h | tee -a "$AUDIT_LOG"
    
    # Check system load
    echo -e "\n10. SYSTEM LOAD:" | tee -a "$AUDIT_LOG"
    uptime | tee -a "$AUDIT_LOG"
    
    echo -e "\n=== Audit Complete ===" | tee -a "$AUDIT_LOG"
}

# Function to generate HTML report
generate_html_report() {
    cat > "$REPORT_FILE" << 'HTML_EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Cloud Security Audit Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #2c3e50; color: white; padding: 20px; }
        .section { margin: 20px 0; padding: 15px; border-left: 4px solid #3498db; }
        .alert { background-color: #f8d7da; border-color: #f5c6cb; color: #721c24; }
        .success { background-color: #d4edda; border-color: #c3e6cb; color: #155724; }
        pre { background-color: #f8f9fa; padding: 10px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Cloud Security Audit Report</h1>
        <p>Generated on: $(date)</p>
    </div>
    
    <div class="section success">
        <h2>Audit Summary</h2>
        <p>This report provides a comprehensive overview of the current security posture of your cloud environment.</p>
    </div>
    
    <div class="section">
        <h2>Detailed Findings</h2>
        <pre>$(cat "$AUDIT_LOG")</pre>
    </div>
    
    <div class="section alert">
        <h2>Recommendations</h2>
        <ul>
            <li>Regularly update system packages</li>
            <li>Monitor failed login attempts</li>
            <li>Review user access permissions quarterly</li>
            <li>Implement log rotation and archiving</li>
            <li>Enable automated security scanning</li>
        </ul>
    </div>
</body>
</html>
HTML_EOF
    
    echo "HTML report generated: $REPORT_FILE"
}

# Run the audit
perform_audit
generate_html_report

echo "Security audit completed successfully!"
echo "Text report: $AUDIT_LOG"
echo "HTML report: $REPORT_FILE"
