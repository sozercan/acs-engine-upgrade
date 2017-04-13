#!/bin/bash
CURRENT_VERSION="v1.5.3"
TARGET_VERSION="v1.6.1"
SSH_KEY=id_rsa

echo "Upgrading kubectl on master..." && \
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
chmod +x ./kubectl && \
mv ./kubectl /usr/local/bin/kubectl && \
echo "Upgrading kubelet and manifests..." && \
grep -rl hyperkube-amd64:$CURRENT_VERSION /etc/kubernetes | xargs sed -i "s@hyperkube-amd64:$CURRENT_VERSION@hyperkube-amd64:$TARGET_VERSION@g" && \
curl -L -sf https://gist.githubusercontent.com/sozercan/fa09f28a2b2d66f3a1143fa04cd19743/raw/ba39560963a65b71e82b8af59d2ed1e6f3f3a34b/acsengine-upgrade.sh | sudo bash

nodes=$(kubectl get node -o name | grep -o 'k8s-agentpool[1-9]-[0-9]*-[0-9]')

for node in $nodes; do
    echo "Draining $node..." && kubectl drain $node --ignore-daemonsets && \

    ssh -l $(logname) -i /home/$(logname)/.ssh/$SSH_KEY -t -oStrictHostKeyChecking=no $node "echo 'Working on $node...' && curl -L -sf https://gist.githubusercontent.com/sozercan/fa09f28a2b2d66f3a1143fa04cd19743/raw/ba39560963a65b71e82b8af59d2ed1e6f3f3a34b/acsengine-upgrade.sh | sudo bash"
done

# echo "Rebooting master..." && \
# reboot