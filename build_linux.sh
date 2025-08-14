#!/bin/bash

# Photobooth Linux Build Script
# This script builds the Flutter photobooth app for Linux deployment

set -e

echo "🚀 Building Photobooth for Linux..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter first: https://flutter.dev/docs/get-started/install/linux"
    exit 1
fi

# Check Flutter version
echo "📋 Flutter version:"
flutter --version

# Enable Linux desktop support
echo "🐧 Enabling Linux desktop support..."
flutter config --enable-linux-desktop

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for Linux release
echo "🔨 Building for Linux (release mode)..."
flutter build linux --release

# Check if build was successful
if [ -d "build/linux/x64/release/bundle" ]; then
    echo "✅ Build successful!"
    echo "📁 Build output: build/linux/x64/release/bundle/"
    
    # Create deployment package
    echo "📦 Creating deployment package..."
    mkdir -p deploy/photobooth
    cp -r build/linux/x64/release/bundle/* deploy/photobooth/
    cp -r assets deploy/photobooth/ 2>/dev/null || echo "ℹ️  No assets folder to copy"
    
    echo "✅ Deployment package ready in: deploy/photobooth/"
    echo "🎯 Executable: deploy/photobooth/io_photobooth"
else
    echo "❌ Build failed!"
    exit 1
fi
