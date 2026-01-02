#!/bin/bash

# Get container IP and update /etc/hosts
CONTAINER_IP=$(hostname -I | awk '{print $1}')
echo "${CONTAINER_IP}	vhcalnplci vhcalnplci.dummy.nodomain" >> /etc/hosts

# Start uuidd service
systemctl start uuidd

# Ensure hostname is set
hostnamectl set-hostname vhcalnplci
systemctl restart systemd-hostnamed

# Start SSH service
systemctl start sshd

# Configure and start firewall
systemctl start firewalld
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

# Display status
echo "==================================="
echo "SAP Lab Environment Ready"
echo "==================================="
echo "Hostname: vhcalnplci"
echo "Container IP: ${CONTAINER_IP}"
echo "Root Password: <hopefully changed>"
echo "==================================="
systemctl status sshd --no-pager
echo "==================================="

# Check Java version
java -version

# If SAP installation files exist, extract them
if [ -f /sapsetup/SYBASE_ASE_TestDrive_2027_Mar_31.rar ]; then
    echo "Extracting SAP installation files..."
    cd /sapsetup
    unrar x SYBASE_ASE_TestDrive_2027_Mar_31.rar
    unrar x TD752SP04part01.rar
    rm -f *.rar
    chmod +x install.sh
    echo "SAP files extracted. Run /sapsetup/install.sh to begin installation."
fi

# Keep container running
exec /usr/lib/systemd/systemd
