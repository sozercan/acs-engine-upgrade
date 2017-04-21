#!/bin/bash
CURRENT_VERSION="v1.5.3"
TARGET_VERSION="v1.6.2"
SSH_KEY="id_rsa"
SCRIPT_URL="https://gist.githubusercontent.com/sozercan/fa09f28a2b2d66f3a1143fa04cd19743/raw/046041b1fc9049090d209cbe9132ed4c823a836a/acsengine-upgrade.sh"
NODES="k8s-agentpool[1-9]-[0-9]*-[0-9]"

echo "Upgrading kubectl on master..." && \
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
chmod +x ./kubectl && \
mv ./kubectl /usr/local/bin/kubectl && \
echo "Upgrading kubelet and manifests..." && \
grep -rl hyperkube-amd64:$CURRENT_VERSION /etc/kubernetes | xargs sed -i "s@hyperkube-amd64:$CURRENT_VERSION@hyperkube-amd64:$TARGET_VERSION@g" && \
curl -L -sf $SCRIPT_URL | sudo bash

nodes=$(kubectl get node -o name | grep -o $NODES)

for node in $nodes; do
    echo "Cordoning $node..." && kubectl cordon $node
done

for node in $nodes; do
    echo "Draining $node..." && kubectl drain $node --ignore-daemonsets && \
    ssh -l $(logname) -i /home/$(logname)/.ssh/$SSH_KEY -t -oStrictHostKeyChecking=no $node "echo 'Working on $node...' && curl -L -sf $SCRIPT_URL | sudo bash"
done

for node in $nodes; do
    echo "Uncordoning $node..." && kubectl uncordon $node
done

echo "Upgrade complete!"
