#!/bin/bash

nmcli con delete enp0s3
nmcli con add type bridge ifname br1000 con-name br1000
nmcli con add type bridge-slave ifname enp0s3 master br1000
nmcli con up br1000

nmcli con mod br1000 ipv4.addresses 192.168.1.13/24
nmcli con mod br1000 ipv4.gateway 192.168.1.1
nmcli con mod br1000 ipv4.method manual
nmcli con up br1000

cat > /tmp/br1000.xml <<EOF
<network>
  <name>br1000</name>
  <forward mode="bridge"/>
  <bridge name="br1000" />
</network>
EOF

virsh net-define /tmp/br1000.xml
virsh net-start br1000
virsh net-autostart br1000

exit 0
