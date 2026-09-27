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

```bash
sudo mkfs.ext4 /dev/sda1
```

## Mount drive

### Create mount path

I have gone with `/mnt/nfs`

```bash
sudo mkdir -p /mnt/nfs
```

### Find your UUID

```bash
sudo blkid /dev/sda1
```

### Open configuration file

```bash
sudo nano /etc/fstab
```

### Add in config

```conf
UUID=<UUID from above>  /mnt/nfs  ext4  defaults,nofail  0  2
```

### Load mounted

Reload your configuration without restarting run this

```bash
sudo mount -a
```

### View block devices with mount paths

```bash
sudo lsblk
```

## Install NFS

To install the server all you need to do is run this playbook

```bash
ansible-playbook ./ansible/playbooks/setup_nfs_server.yaml
```

To ensure our cluster worker nodes get NFS client just run the update playbook

```bash
ansible-playbook ./ansible/playbooks/update.yaml
```