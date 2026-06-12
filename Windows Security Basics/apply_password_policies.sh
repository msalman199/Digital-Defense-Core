#!/bin/bash

# Apply password policies using samba-tool
echo "Applying password policies..."

# Set domain password policy
sudo samba-tool domain passwordsettings set --complexity=on
sudo samba-tool domain passwordsettings set --history-length=12
sudo samba-tool domain passwordsettings set --min-pwd-length=12
sudo samba-tool domain passwordsettings set --min-pwd-age=1
sudo samba-tool domain passwordsettings set --max-pwd-age=90

# Set account lockout policy
sudo samba-tool domain passwordsettings set --account-lockout-threshold=5
sudo samba-tool domain passwordsettings set --account-lockout-duration=30

echo "Password policies applied successfully!"

# Display current settings
echo "Current password policy settings:"
sudo samba-tool domain passwordsettings show
