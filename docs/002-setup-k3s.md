# Setup k3s cluster

This part if all automated and all we need to do is run 3 playbooks. We have seperated them out

```bash
ansible-playbook ./ansible/playbooks/k3s/k3s_init.yaml -K
ansible-playbook ./ansible/playbooks/k3s/k3s_server.yaml -K
ansible-playbook ./ansible/playbooks/k3s/k3s_agent.yaml -K
```