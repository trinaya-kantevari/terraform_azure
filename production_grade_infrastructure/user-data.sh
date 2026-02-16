# This script runs automatically during the initialization of every new VM instance.
# It configures each VM with all the necessary packages during startup.
usermod -a -G azureuser azureuser
sudo apt update -y
sudo apt install nginx -y