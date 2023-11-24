#!/bin/bash

# Get the device path (like /dev/sda1)
DEVICE_PATH=$1

# Extract the device name and label
DEVICE_NAME=$(basename $DEVICE_PATH)
DEVICE_LABEL=$(lsblk -o LABEL -nr $DEVICE_PATH | tr -d ' ')

# Define the mount point, use label if available, else use device name
MOUNT_POINT="/mnt/${DEVICE_LABEL:-$DEVICE_NAME}"

# Create the mount directory
mkdir -p $MOUNT_POINT

# Filesystem check and auto-repair
fsck -a $DEVICE_PATH

# Mount the device
mount $DEVICE_PATH $MOUNT_POINT
