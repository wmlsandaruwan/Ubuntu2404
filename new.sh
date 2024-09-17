#!/bin/bash

# Function to update the hostname
update_hostname() {
    local new_hostname=$1

    echo "Changing hostname to $new_hostname"

    # Update /etc/hostname
    echo "$new_hostname" > /etc/hostname

    # Update /etc/hosts (replace old hostname with new one)
    sed -i "s/$(hostname)/$new_hostname/g" /etc/hosts

    # Apply the new hostname
    hostnamectl set-hostname $new_hostname

    echo "Hostname changed successfully to $new_hostname"
}

# Function to update the network configuration
update_network_config() {
    local new_ip=$1
    local subnet_mask=$2
    local gateway=$3
    local primary_dns=$4
    local secondary_dns=$5

    echo "Changing network configuration"
    
    # The configuration file for Netplan
    netplan_config_file="/etc/netplan/00-installer-config.yaml"

    # Check if the file exists, otherwise create it
    if [ -f "$netplan_config_file" ]; then
        # Backup the current configuration
        cp $netplan_config_file $netplan_config_file.bak
    else
        touch $netplan_config_file
    fi

    # Ensure the interface is cleared of any previous IP configuration
    ip addr flush dev ens18

    # Update the network configuration with default route syntax
    cat > $netplan_config_file <<EOL
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: no
      addresses:
        - $new_ip/$subnet_mask
      routes:
        - to: 0.0.0.0/0
          via: $gateway
      nameservers:
        addresses:
          - $primary_dns
          - $secondary_dns
EOL

    # Fix the file permissions
    chmod 600 $netplan_config_file

    # Apply the network configuration
    netplan apply

    echo "Network configuration applied successfully!"
}

# Main script logic
echo "Enter new hostname: "
read new_hostname

echo "Enter new IP address (e.g., 192.168.1.10): "
read new_ip

echo "Enter subnet mask (e.g., 24 for 255.255.255.0): "
read subnet_mask

echo "Enter default gateway: "
read gateway

echo "Enter primary DNS: "
read primary_dns

echo "Enter secondary DNS (optional): "
read secondary_dns

# Call the functions
update_hostname $new_hostname
update_network_config $new_ip $subnet_mask $gateway $primary_dns $secondary_dns

# Restart networking service to ensure all changes are applied
echo "Restarting networking service..."
systemctl restart systemd-networkd

echo "All changes applied! System hostname and network configuration updated."
