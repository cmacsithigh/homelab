# Prerequisites

##  Edit this file

```bash
sudo nano /boot/firmware/cmdline.txt
```

## Add this to the existing line

```bash
cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```