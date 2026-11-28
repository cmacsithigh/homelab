# Setup k3s cluster

Run the playbooks in order. Configure Tailscale first, then initialize the cluster, install the pinned K3s server version, apply its configuration, and install the agents.

```bash
ansible-playbook ./ansible/playbooks/tailscale.yaml
ansible-playbook ./ansible/playbooks/k3s/k3s_init.yaml
ansible-playbook ./ansible/playbooks/k3s/k3s_server_version.yaml
ansible-playbook ./ansible/playbooks/k3s/k3s_server_config.yaml
ansible-playbook ./ansible/playbooks/k3s/k3s_agents.yaml
ansible-playbook ./ansible/playbooks/install_cilium.yaml
```

The Cilium playbook checks that K3s is configured with `flannel-backend: none`,
`disable-network-policy: true`, and `disable-kube-proxy: true`. It installs the
pinned Cilium CLI and Cilium version, waits for Cilium to be ready, and runs the
connectivity test. Envoy is disabled and Hubble, Relay, and the UI are enabled.