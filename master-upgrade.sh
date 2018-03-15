#!/bin/bash
#
echo $(date +"%F %T%z") "starting script master-upgrade.sh"
CURRENT_VERSION=$1
TARGET_VERSION=$2
echo "CURRENT_VERSION: $CURRENT_VERSION"
echo "TARGET_VERSION: $TARGET_VERSION"
SCRIPT_URL="https://raw.githubusercontent.com/sozercan/acs-engine-upgrade/master/acsengine-upgrade.sh"

echo "Upgrading kubectl on master..." && \
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
chmod +x ./kubectl && \
mv ./kubectl /usr/local/bin/kubectl

echo "Upgrading hyperkube on master..."
grep -rl hyperkube-amd64:v$CURRENT_VERSION /etc/kubernetes | xargs sed -i "s@hyperkube-amd64:v$CURRENT_VERSION@hyperkube-amd64:v$TARGET_VERSION@g"
echo "Calling acsengine-upgrade on master..."
curl -LOk $SCRIPT_URL && sudo bash acsengine-upgrade.sh $CURRENT_VERSION $TARGET_VERSION

echo $(date +"%F %T%z") "ended script master-upgrade.sh"