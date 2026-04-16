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
1. controller for a resource handles the 