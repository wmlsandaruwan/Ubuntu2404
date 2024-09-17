#!/bin/bash

# Function to update hostname
update_hostname() {
    local new_hostname=$1
    echo "Changing hostname to $new_hostname"
    
    # Update the hostname in the /etc/hostname file
    echo $new_hostname > /etc/hostname
    
    # Update the hostname in the /etc/hosts file
    sed -i "s/127.0.1.1.*/127.0.1.1 $new_hostname/g" /etc/hosts
    
    # Apply the new hostname immediately
    hostnamectl set-hostname $new_hostname
}

# Function to update the network configuration
update_network_config() {
    local new_ip=$1
    local subnet_mask=$2
    local gateway=$3
    local primary_dns=$4
    local secondary_dns=$5

    echo "Changing network configuration"
    
    # The configuration file for Netplan (used in Ubuntu 24.04)
    netplan_config_file="/etc/netplan/00-installer-config.yaml"

    # Backup the current configuration
    cp $netplan_config_file $netplan_config_file.bak

    # Update the network configuration
    cat > $netplan_config_file <<EOL
network:
  version: 2
  ethernets:
    ens18:
      addresses:
        - $new_ip/$subnet_mask
      gateway4: $gateway
      nameservers:
        addresses:
          - $primary_dns
          - $secondary_dns
EOL

    # Apply the network configuration
    netplan apply
}

# Main script execution

# Prompt the user for input
echo "Enter the new hostname:"
read new_hostname

echo "Enter the new IP address (e.g., 192.168.1.100):"
read new_ip

echo "Enter the subnet mask (e.g., 24 for 255.255.255.0):"
read subnet_mask

echo "Enter the default gateway (e.g., 192.168.1.1):"
read gateway

echo "Enter the primary DNS (e.g., 8.8.8.8):"
read primary_dns

echo "Enter the secondary DNS (e.g., 8.8.4.4):"
read secondary_dns

# Call the functions to update the hostname and network configuration
update_hostname $new_hostname
update_network_config $new_ip $subnet_mask $gateway $primary_dns $secondary_dns

echo "Changes applied successfully!"
