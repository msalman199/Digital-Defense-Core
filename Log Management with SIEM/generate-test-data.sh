#!/bin/bash

echo "Generating test security events..."

# Generate failed login attempts
for i in {1..5}; do
    logger -p auth.info "sshd[$$]: Failed password for testuser from 192.168.1.100 port 22 ssh2"
    sleep 1
done

# Generate successful login
logger -p auth.info "sshd[$$]: Accepted password for admin from 192.168.1.50 port 22 ssh2"

# Generate sudo usage
logger -p auth.info "sudo: admin : TTY=pts/0 ; PWD=/home/admin ; USER=root ; COMMAND=/bin/ls"

# Generate web traffic
curl -s http://localhost/ > /dev/null
curl -s http://localhost/admin > /dev/null
curl -s http://localhost/test.php?id=1%20UNION%20SELECT > /dev/null

echo "Test data generated successfully"
