#!/bin/bash

# Create the automount script
cat <<EOF | sudo tee /usr/local/bin/automount_usb.sh
#!/bin/bash

DEVICE_PATH=\$1
DEVICE_NAME=\$(basename \$DEVICE_PATH)
DEVICE_LABEL=\$(lsblk -o LABEL -nr \$DEVICE_PATH | tr -d ' ')
MOUNT_POINT="/mnt/\${DEVICE_LABEL:-\$DEVICE_NAME}"

mkdir -p \$MOUNT_POINT
fsck -a \$DEVICE_PATH
mount \$DEVICE_PATH \$MOUNT_POINT
EOF

# Make the automount script executable
sudo chmod +x /usr/local/bin/automount_usb.sh

# Create the udev rule
cat <<EOF | sudo tee /etc/udev/rules.d/99-usb-automount.rules
ACTION=="add", KERNEL=="sd[a-z][1-9]", SUBSYSTEM=="block", RUN+="/usr/local/bin/automount_usb.sh %E{DEVNAME}"
EOF

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "USB Automount setup complete."
