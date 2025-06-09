Requirements: 
Instance type: t3.mdeium 
storage:50GB

# Resize EBS Storage

CHECCK THE PARTITIONS
```
lsblk
```

Use a tool like growpart to resize the existing partition to fill the available space.This will resize the fourth partition (nvme0n1p4) to use the remaining unallocated space on the disk.
```
sudo growpart /dev/nvme0n1 4
```

Extend the Logical Volumes
Decide how much space to allocate to each logical volume. For example, to extend both the root and /var logical volumes:

```
sudo lvextend -l +50%FREE /dev/RootVG/rootVol
sudo lvextend -l +50%FREE /dev/RootVG/varVol
```

After extending the logical volumes, resize the filesystems to utilize the additional space.

For the root filesystem:

```
sudo xfs_growfs /
```

For the /var filesystem:

```
sudo xfs_growfs /var
```
# INSTALL DOCKER kUBECTL EKSCTL FOR CLUSTER SET-UP

INSTALL DOCKER

```
curl https://raw.githubusercontent.com/Cheswini0097/docker2/refs/heads/main/installdocker.sh |sudo bash
```

INSTALL KUBECTL

```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.16/2024-09-11/bin/linux/amd64/kubectl
```

Apply execute permissions to the binary:

```
chmod +x ./kubectl
```

Move kubectl file

```
sudo mv kubectl /usr/local/bin/kubectl
```

Check Kubectl version

```
kubectl version
```

INSTALL EKSCTL

```
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
```

Download eksctl.

```
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
```

EXTRACT THE FILES.

```
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
```

MOVE THE FILES FOR LOCAL BIN TO GET ACCES FOR EVERYONE

```
sudo mv /tmp/eksctl /usr/local/bin
```

Check the version

```
eksctl version
```

