# step 1: enable the chrony service (used to synchronise the clock across the nodes)
sudo apt-get install -y chrony
systemctl enable --now chrony
systemctl status --no-pager chrony # to see the status of chrony 
chronyc sources -v # displays detailed info about NTP (Network Time Protocol)

# step 2: disable SWAP (k8s assumes all memory comes from RAM, SWAP may cause hinderance in providing the memory to POD)
swapoff -a
free -h # shows the status of free memory
sed -e '/swap/ s/^#*/#/' -i /etc/fstab # remove the existence of swap from filesystem, so that it persists in reboot
