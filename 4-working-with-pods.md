# POD
1. smallest deployable unit in kubernetes
2. contains containers that are co-located and co-schduled and uses shared storage and other resources as well.
3. shared namespaces
4. ephemeral

## Two types of Pod: single container pod, multi container pod

### Single container pod
1. one container per pod
2. pod acts as a wrapper around that container
3. kubernetes don't interact directly to the container, it interact only to the pods

### Multi container pod
1. full application running in a pod, containing multiple containers, communicating with each other by using some shared storage or volume.

## pods and controllers
1. controller for a resource handles the replication, roll out and automatic healing in case of pod failure.
2. If a pod failed due to some issue on the node, the controller make sure that the pod gets restarted on some other node.
3. Egs are: deployment, daemon set, stateful set 

## Pod networking
1. each ```pod``` is assigned a ```unique IP address```
2. ```Each container in a pod``` shares the ```same network namespace```
3. ```Each container within the same pod``` can communicate with ```each other on localhost```.

## Static pod
1. Static pod is created by kubelet daemon without API server observing it.
2. static pods bound to only one kubelet on a specfic node
3. kubelet tries to create a mirror pod on kubernetes API server for each static pod.

## init containers
1. other containers only start if init container reaches to completion
2. if init container fails then kubelet keeps on restarting the init container until it is succesfully completed.
3. but if the restartpolicy is set to 'never' and init container fails, the kubernetes treat the entire pod as failed.

## Privileged mode for containers
the processes running in the privileged container gets the same level of accesses as that of processes that are running outside the privileged container.

### pod phases
## pending
pod is accepted by the kubernetes cluster, but it is in pending state because it is not yet bound to any node
## running
pod is bound to a node and all the containers are created.
## suceeded
all containers in a pod are terminated in success and will not be restarted.
## failed
all containers in a pod are terminated, with one container terminted with failed status.
## unknown
somehow the status of the pod can't be obtained

### pod conditions
a pod has podstatus, which has an array of podConditions through which a pod has or hasn't passed:
## podscheduled
a pod is bound to a node
## containersready
all containers in the pod are ready
## initialized
all init containers have started successfully
## ready
pod is able to serve requests and should be added to load balancing pools of all matching services

### Container Probe
1. Container probe is a diagonstic check performed periodically by kubelet on the container.
2. to do the diagnostic check, the kublet calls the handler implemented inside the container.
3. three types of handlers:
    - ``` ExecAction ```: kubelet runs the command that is present inside the container. The diagnosis is successful if the container returns the exit code as 0.
    - ``` TCPSocketAction```: kubelet does a tcp check on pod's IP against a specific port. The diagnosis is successful if the port is open.
    - ``` HTTPGetAction ```: kubelet runs the HTTP Get command on pod's IP on a specific port and a specific path. The diagonosis is considered succesful if the the HTTP response has status code above 200 and below 400.
4. There are two type of probe:
    - ```Liveliness probe ```: tells if container is running; if this probe is not given, then default state is success; if the liveliness probe has failed, then pod restarts the container based on the restart policy of the container.
    - ``` Readiness probe ```: tells if the container is ready to take requests; if the readiness probe failed, then kubernetes stop sending requests to the container, the container is removed from the service's loadbalancer endpoints but it is not restarted; mostly used in order to prevent users from hitting the 'half baked pod' with their requests.

### Container states
1. ``` waiting ```: eg: pulling the images from the container registry, applying secret data; during such times container is in the waiting state.
2. ``` running```: container is running without any issues
3. ``` terminated```: container from the running state goes to terminted, either it is completed successfully or goes into failure, in either case, continer is terminated.

