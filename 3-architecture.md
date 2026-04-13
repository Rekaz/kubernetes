# Master components
1. kube apiserver
2. kube controller manager
3. etcd
4. kube-scheduler
5. cloud controller manager

## Kube apiserver
- uses REST api to communicate to all other components.
- also communicates to the user, nodes and other applications
- acts as ```gatekeeper of cluster``` by handling: 
    - authentication and authorization 
    - request validation
    - mutation and admission control

## etcd
- cluster data store
- ```stores the state of cluster as key value```, used for persisting cluster state

## kube controller manager
- monitors the state of the cluster
- responsible to bring the cluster in a particular desired state

## kube scheduler
- ```finds the matching resources based on workloads requirements```
- the requirement includes:
    - affinity and anti-affinity
    - hardware requirements
    - any other custom resource requirements

## cloud controller manager
- used to manage the cluster via cloud provider services

# Node Components
1. Kubelet
2. Kube-proxy
3. Container Runtime Interface

## Kubelet
- acts as node agent and ```manages lifecycle of pod on node```

## Kube-proxy
- used to manage the networking on the node and performs connection forwarding and load balancing for kubernetes cluster services.

## Container Runtime
- wrt kubernetes, container runtime is used to execute and manage containers.
- different CRIs:
    - containerd (docker)
    - Cri-o
    - Rkt
