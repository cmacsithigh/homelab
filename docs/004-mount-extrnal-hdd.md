# Mount external hard drive

For extra storage we have added an external hard drive. This will need to be formatted and permenantly moutned in order to work correctly.

## Format drive

### Wipe Existing Signatures

Remove any existing headers and overlapping signatures from the base drive so `fdisk` won't get confused:

```bash
sudo wipefs -a /dev/sda
```

### Partition the Base Drive

Open the partition utility:

```bash
sudo fdisk /dev/sda
```

### Inside the interactive fdisk prompt, press the following keys one after another (press Enter after each):

```md
    g — Creates a fresh, clean GPT partition table.
    n — Creates a new partition.
    Enter — Accepts the default partition number (1).
    Enter — Accepts the default first sector.
    Enter — Accepts the default last sector (allocates the full disk space).
    w — Writes the new partition table and exits.
```

### Force the Kernel to Update

Run partprobe to ensure the operating system immediately registers the new partition layout without requiring a system reboot:

```bash
sudo partprobe /dev/sda
```

### Format the New Partition to ext4

Now that the disk is cleanly partitioned, format your new partition (/dev/sda1) with the ext4 filesystem:

## Install NFS

The NFS server playbook creates `/mnt/nfs`, reads the filesystem UUID from
`/dev/sda1`/`/dev/sdb1`, adds the UUID-based mount to `/etc/fstab`, mounts the drive, and
shows the resulting block devices. If your drive uses a different device path,
override `nfs_storage_device` when running the playbook.

```bash
ansible-playbook ./ansible/playbooks/setup_nfs_server.yaml
```

To ensure our cluster worker nodes get NFS client just run the update playbook

```bash
ansible-playbook ./ansible/playbooks/update.yaml
```