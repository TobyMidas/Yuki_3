#!/bin/bash

WEB_IP=$(vagrant ssh web -c 'hostname -I' | awk '{print $2}')
DB_IP=$(vagrant ssh db -c 'hostname -I' | awk '{print $2}')

cat <<EOF > hosts
[web]
$WEB_IP

[db]
$DB_IP
EOF

echo "Inventory generated:"
cat hosts

vagrant ssh web -c "
sudo apt update &&
sudo apt install -y ansible &&
ansible-playbook -i /vagrant/hosts /vagrant/playbook.yml
"