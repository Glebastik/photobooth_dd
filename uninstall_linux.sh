#!/bin/bash

# Photobooth Linux Uninstallation Script
# This script removes the photobooth application and service

set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root (use sudo)"
    exit 1
fi

echo "🗑️ Uninstalling Photobooth from Linux..."

# Stop and disable service
echo "⏹️ Stopping and disabling service..."
systemctl stop photobooth.service 2>/dev/null || echo "Service was not running"
systemctl disable photobooth.service 2>/dev/null || echo "Service was not enabled"

# Remove systemd service file
echo "🗂️ Removing systemd service..."
rm -f /etc/systemd/system/photobooth.service
systemctl daemon-reload

# Remove application directory
echo "📁 Removing application directory..."
rm -rf /opt/photobooth

# Remove user (optional - commented out to preserve user data)
# echo "👤 Removing photobooth user..."
# userdel photobooth 2>/dev/null || echo "User removal skipped"

echo "✅ Uninstallation complete!"
echo "ℹ️ The photobooth user was preserved. Remove manually if needed: sudo userdel photobooth"
