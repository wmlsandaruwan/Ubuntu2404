# Ubuntu2404
Useful Ubuntu 24.04 Scripts 

new.sh
Explanation of the Script:
Hostname Update:
The script prompts for the new hostname, updates /etc/hostname, and modifies /etc/hosts to ensure the new hostname is applied immediately.
Network Configuration Update:
It asks for the IP address, subnet mask, gateway, and DNS information.
The script generates a new Netplan configuration file (/etc/netplan/00-installer-config.yaml), which is used for network settings on Ubuntu 24.04.
After updating the file, it applies the new configuration using netplan apply.
How to Use:
Save this script to a file, e.g., update_server.sh.
Make it executable: chmod +x update_server.sh
Run it: sudo ./update_server.sh
