# Setup k3s cluster

Run the playbooks in order. Configure Tailscale first, then initialize the cluster, install the pinned K3s server version, apply its configuration, and install the agents.

```bash
ansible-playbook ./ansible/playbooks/tailscale.yaml
ansible-playbook ./ansible/playbooks/k3s/k3s_init.yaml
ansible-playbook ./ansible/playbooks/k3s/k3s_server_version.yaml
ansible-playbook ./ansible/playbooks/k3s/k3s_server_config.yaml
ansible-playbook ./ansible/playbooks/k3s/k3s_agents.yaml
```