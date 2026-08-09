# Prerequisites

##  Edit this file

### Newer raspberry pi

```bash
sudo nano /boot/firmware/cmdline.txt
```

### Older raspberry pis

```bash
sudo nano /boot/cmdline.txt
```

## Add this to the existing line

```bash
cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```