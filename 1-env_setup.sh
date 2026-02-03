echo -e "\033[0;32mStep 1: enable the chrony service (used to synchronise the clock across the nodes)\033[0m"
sudo apt-get install -y chrony
sudo systemctl enable --now chrony
sudo systemctl status --no-pager chrony # to see the status of chrony 
chronyc sources -v # displays detailed info about NTP (Network Time Protocol)

echo -e "\033[0;32mstep 2: disable SWAP (k8s assumes all memory comes from RAM, SWAP may cause hinderance in providing the memory to POD)\033[0m"
sudo swapoff -a
free -h # shows the status of free memory
sudo sed -e '/swap/ s/^#*/#/' -i /etc/fstab # remove the existence of swap from filesystem, so that it persists in reboot

echo -e "\033[0;32mstep 3: enable kernel modules and sysctl\033[0m"
# enable the ip table on node to see bridged ip traffic
sudo modprobe br_netfilter overlay
# sudo touch /etc/sysctl.d/kubernetes.conf
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf overlay br_netfilter 
EOF
sudo sysctl --system

echo -e "\033[0;32mstep 4: configure docker repository and install docker engine\033[0m"

# first, install some essential tools
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common gnupg2 wget curl git
sudo touch /etc/apt/keyringscurl
sudo install -m 0755 -d /etc/apt/keyringscurl gpg
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# second, add docker repo to apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# update the packages
sudo apt-get update -y

echo -e "\033[0;32mstep 5: setting up and installing containerd\033[0m"
sudo apt-get install -y containerd.io
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo grep "SystemdCgroup" /etc/containerd/config.toml
sudo sed -i '/SystemdCgroup/ s/false/true/' /etc/containerd/config.toml
sudo grep "SystemdCgroup" /etc/containerd/config.toml

# When using crictl to interact with container runtimes (like containerd, CRI-O, or dockerd), the command requires knowing the endpoint (i.e., where the runtime's API is listening for connections). These endpoints are typically Unix socket paths used for communication between the Kubernetes components and the container runtime.
sudo tee /etc/crictl.yaml <<EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
EOF
echo -e "\033[0;34mprint the file\033[0m"
cat /etc/crictl.yaml
#restart and enable the containerd
sudo systemctl restart containerd
sudo systemctl enable --now containerd
sudo systemctl status --no-pager containerd

echo -e "\033[0;32mStep 6: Configure Kubernetes Repository and Install Kubernetes\033[0m"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet=1.33.0-1.1 kubeadm=1.33.0-1.1 kubectl=1.33.0-1.1

echo -e "\033[0;32mStep 7: Add Package Version Lock\033[0m"
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
sudo systemctl status kubelet --no-pager

