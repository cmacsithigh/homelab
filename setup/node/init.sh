##
## Before running this file ensure you have checked he prerequisites.md 
## 

##
## Get token from server
## sudo cat /var/lib/rancher/k3s/server/node-token
##

curl -sfL https://get.k3s.io | K3S_TOKEN=xxx K3S_URL=https://<ip>:6443 sh -

sudo service k3s-agent status
