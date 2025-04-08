#!/bin/bash

# Script to update CentOS machines before installation
# This script performs system updates using dnf

echo "=== System Update Script ==="
echo "Updating system packages on $(hostname)"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

# Check if dnf is available
if ! command -v dnf &> /dev/null; then
  echo "dnf package manager not found. This script is designed for CentOS 8+ or RHEL 8+."
  
  # Check if yum is available as fallback
  if command -v yum &> /dev/null; then
    echo "Using yum instead of dnf..."
    yum update -y
    yum upgrade -y
    echo "System update completed successfully using yum."
    exit 0
  else
    echo "Neither dnf nor yum found. Cannot update system."
    exit 1
  fi
fi

# Update package lists and upgrade packages
echo "Running system update..."
dnf update -y
echo "Running system upgrade..."
dnf upgrade -y

# Clean up
echo "Cleaning up..."
dnf clean all

echo "System update completed successfully."
echo "The system is now ready for installation."
