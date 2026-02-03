# Step 1 - initializing kubeadm: used to set up the control plane node using kubeadm init command, which configures the cluster
# Step 2 - overlay network: used to enalbe inter pod communication
# Step 3 - joining nodes to the cluster: uses token generated during kubeadm init, that are used to join worker nodes to cluster using kubeadm join command
# Step 4 - labelling the nodes: used during schduling and management

echo -e "\033[0;32mStep 1: Initializing kubeadm\033[0m"
# to start the deployment of kubernetes cluster
kubeadm init --pod-network-cidr=10.10.0.0/16 | tee bootstrap.txt
# set variables (given in instructions in the terminal)
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


echo -e "\033[0;32mStep 2: set the network plugins for inter pod communication\033[0m"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.2/manifests/calico.yaml # used calico plugin for inter pod communication
kubectl get nodes # to see nodes in cluster
kubectl cluster-info # to see cluster info

# NOTE: run above commands on the other worker nodes

echo -e "\033[0;32mStep 3: joining nodes to cluster\033[0m"
# don't run the below command directly, you will get the actual kubeadm join command when you run the kubeadm init command
#kubeadm join 192.168.100.11:6443 –token <token-id> \ -- discovery-token-ca-cert-hash <hash-id>

echo -e "\033[0;32mStep 4: Labeling the nodes\033[0m"
# label the worker nodes
# kubectl label node eoc-node1 node-role.kubernetes.io/node="worker1"
# kubectl label node eoc-node2 node-role.kubernetes.io/node="worker2"

# to check the status of cluster
kubectl get --raw='/readyz?verbose'
curl -k https://localhost:6443/livez?verbose

#to see kubeadm version in json format
kubeadm version -o json