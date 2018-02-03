# acs-engine-upgrade
⚒ Script that upgrades existing ACS Kubernetes clusters

Note: acs-engine has an official upgrade method now: https://github.com/Azure/acs-engine/tree/master/examples/k8s-upgrade

__USE IT ON YOUR OWN RISK - DO NOT USE IN PRODUCTION__

* Make sure to copy your ssh key into master node so it can ssh into agent nodes

```
export CLUSTERNAME=<resource group name>
export REGION=<Azure region>
export ADMIN=<adminuser defined in api model>
scp -r ~/.ssh/id_rsa* $ADMIN@$CLUSTERNAME.$REGION.cloudapp.azure.com:~/.ssh
```

Execute the following on a master node

```
git clone https://github.com/sozercan/acs-engine-upgrade
```


![before](http://i.imgur.com/Oz2pvFC.png)

```
export CURRENT_VERSION=1.6.12
export TARGET_VERSION=1.9.2

sudo bash upgrade.sh $CURRENT_VERSION $TARGET_VERSION
```

![after](http://i.imgur.com/2OjihLM.png)
