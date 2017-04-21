# acs-engine-upgrade
⚒ Script that upgrades existing ACS Kubernetes clusters

__USE IT ON YOUR OWN RISK - DO NOT USE IN PRODUCTION__

* Make sure to copy your ssh key into master node so it can ssh into agent nodes

`export $CLUSTERNAME=<resource group name>`

`export $REGION=<Azure region>`

`scp -r ~/.ssh/id_rsa* $CLUSTERNAME.$REGION.cloudapp.azure.com:/home/$USER`

![before](http://i.imgur.com/Oz2pvFC.png)

`sudo ./upgrade.sh`

![after](http://i.imgur.com/2OjihLM.png)
