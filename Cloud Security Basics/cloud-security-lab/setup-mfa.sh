#!/bin/bash

USER=$1
if [ -z "$USER" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

echo "Setting up MFA for user: $USER"

# Switch to the user and run google-authenticator
sudo -u "$USER" google-authenticator -t -d -f -r 3 -R 30 -W

echo "MFA setup completed for $USER"
echo "The user should scan the QR code with their authenticator app"
