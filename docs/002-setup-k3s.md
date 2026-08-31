# Setup k3s cluster

This part if all automated and all we need to do is run this playbook

```bash
ansible-playbook ./ansible/playbooks/002-k3s-setup.yaml -K
```

You might need to run this playbook with `-K` on the first time to ensure sudo password is asked. This is due to a higher level of permissions being required.

Once we have k3s installed across all of our server node and worker nodes we need to ensure our localhost setup is pointing to the correct cluster. This is achived by running the following playbook

```bash
ansible-playbook ./ansible/playbooks/003-local-setup.yaml
```