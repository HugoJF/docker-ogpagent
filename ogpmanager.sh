#!/bin/bash

/usr/local/bin/gomplate -f /opt/OGP/templates/Config.pm.tmpl -o /opt/OGP/Cfg/Config.pm
# /usr/local/bin/gomplate -f /opt/OGP/templates/Config.tmpl.yml -o /opt/OGP/Cfg/Config.yml
/usr/local/bin/gomplate -f /opt/OGP/templates/Preferences.pm.tmpl -o /opt/OGP/Cfg/Preferences.pm

# bind_ingress=`docker network inspect --format='{{ (index .IPAM.Config 0).Gateway }}' ingress`
# bind_gateway=`docker network inspect --format='{{ (index .IPAM.Config 0).Gateway }}' docker_gwbridge`

# echo 'bind_gateway: '$bind_gateway > /opt/OGP/Cfg/bind.yml
# echo 'bind_ingress: '$bind_ingress >> /opt/OGP/Cfg/bind.yml

# echo 'The bindGW '$bind_gateway

echo "Mounting storage on $NFS_SERVER"
mkdir /home/ogp_agent/OGP_User_Files
mount -o vers=4,loud,user_xattr -v $NFS_SERVER:/ /home/ogp_agent/OGP_User_Files

chmod +x /opt/OGP/ogp_agent_run
echo "Starting DockerOGP"

gateway_watch &
tail -F /opt/OGP/ogp_agent.log &
su ogp_agent -c "cd /opt/OGP/; ./ogp_agent_run"
