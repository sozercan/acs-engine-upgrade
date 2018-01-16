# acs-engine-upgrade
⚒ Script that upgrades existing ACS Kubernetes clusters

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
sudo apt install unzip
curl -LOk https://github.com/ritazh/acs-engine-upgrade/archive/master.zip && unzip master.zip && cd acs-engine-upgrade-master
```


![before](http://i.imgur.com/Oz2pvFC.png)

`sudo bash upgrade.sh 1.6.12 1.7.7`

![after](http://i.imgur.com/2OjihLM.png)
