#!/bin/bash
CURRENT_VERSION="v1.5.3"
TARGET_VERSION="v1.6.2"
SSH_KEY="id_rsa"
SCRIPT_URL="https://gist.githubusercontent.com/sozercan/fa09f28a2b2d66f3a1143fa04cd19743/raw/4c01c80e3ccf4f0d9159875aa61b421790da26d0/acsengine-upgrade.sh"

echo "Upgrading kubectl on master..." && \
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
chmod +x ./kubectl && \
mv ./kubectl /usr/local/bin/kubectl && \
echo "Upgrading kubelet and manifests..." && \
grep -rl hyperkube-amd64:$CURRENT_VERSION /etc/kubernetes | xargs sed -i "s@hyperkube-amd64:$CURRENT_VERSION@hyperkube-amd64:$TARGET_VERSION@g" && \
curl -L -sf $SCRIPT_URL | sudo bash

nodes=$(kubectl get node -o name | grep -o 'k8s-agentpool[1-9]-[0-9]*-[0-9]')

for node in $nodes; do
    echo "Draining $node..." && kubectl drain $node --ignore-daemonsets --delete-local-data && \
    ssh -l $(logname) -i /home/$(logname)/.ssh/$SSH_KEY -t -oStrictHostKeyChecking=no $node "echo 'Working on $node...' && curl -L -sf $SCRIPT_URL | sudo bash" && \
    kubectl uncordon $node
done
