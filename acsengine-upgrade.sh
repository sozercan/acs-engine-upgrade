#!/bin/bash
#
echo $(date +"%F %T%z") "starting script acsengine-upgrade.sh"
CURRENT_VERSION=$1
TARGET_VERSION=$2
echo "CURRENT_VERSION: $CURRENT_VERSION"
echo "TARGET_VERSION: $TARGET_VERSION"

sed -i -e "s@hyperkube-amd64:v$CURRENT_VERSION@hyperkube-amd64:v$TARGET_VERSION@g" /etc/default/kubelet && \

if [[ $TARGET_VERSION == *"1.6"* ]]; then
  echo "Upgrading to 1.6"
  echo "--config is deprecated in 1.6"
  sed -i -e "s@config=/etc/kubernetes/manifests@pod-manifest-path=/etc/kubernetes/manifests@g" /etc/systemd/system/kubelet.service
  echo "enabling multi-gpu support"
  sed -i  '/\--pod-manifest-path=\/etc\/kubernetes\/manifests \\/a--feature-gates=Accelerators=true \\' /etc/systemd/system/kubelet.service
fi
# restarting kubelet
systemctl daemon-reload && \
systemctl restart kubelet