#!/bin/bash

# Photobooth Linux Installation Script
# This script installs the photobooth application as a system service

set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root (use sudo)"
    exit 1
fi

echo "🚀 Installing Photobooth on Linux..."

# Create photobooth user if it doesn't exist
if ! id "photobooth" &>/dev/null; then
    echo "👤 Creating photobooth user..."
    useradd -r -s /bin/false -d /opt/photobooth photobooth
fi

# Create application directory
echo "📁 Creating application directory..."
mkdir -p /opt/photobooth
mkdir -p /opt/photobooth/data

# Copy application files
echo "📦 Copying application files..."
if [ -d "deploy/photobooth" ]; then
    cp -r deploy/photobooth/* /opt/photobooth/
else
    echo "❌ Build files not found! Please run build_linux.sh first."
    exit 1
fi

# Set permissions
echo "🔐 Setting permissions..."
chown -R photobooth:photobooth /opt/photobooth
chmod +x /opt/photobooth/io_photobooth

# Install systemd service
echo "⚙️ Installing systemd service..."
cp photobooth.service /etc/systemd/system/
systemctl daemon-reload

# Enable and start service
echo "🔄 Enabling and starting service..."
systemctl enable photobooth.service
systemctl start photobooth.service

# Check service status
echo "📊 Service status:"
systemctl status photobooth.service --no-pager

echo "✅ Installation complete!"
echo ""
echo "📋 Useful commands:"
echo "  • Check status: sudo systemctl status photobooth"
echo "  • Start service: sudo systemctl start photobooth"
echo "  • Stop service: sudo systemctl stop photobooth"
echo "  • Restart service: sudo systemctl restart photobooth"
echo "  • View logs: sudo journalctl -u photobooth -f"
echo "  • Disable autostart: sudo systemctl disable photobooth"
echo ""
echo "📁 Application installed in: /opt/photobooth"
echo "📄 Logs available via: journalctl -u photobooth"
