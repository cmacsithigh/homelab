##
## Before running this file ensure you have checked he prerequisites.md 
## 

curl -sfL https://get.k3s.io | sh - 

sudo service k3s status

# Check for Ready node, takes ~30 seconds 
sudo k3s kubectl get node 

# Ensure we don't need sudo
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# Set config
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc

source ~/.bashrc

# Download and install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Download and install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# Install flux
helm install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
  --namespace flux-system \
  --create-namespace

sleep 15s

kubectl apply -f flux.yaml