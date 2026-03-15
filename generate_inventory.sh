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

#This updates hosts and downloads ansible
for VM in web db; do
    echo "Running playbook on $VM"
    vagrant ssh $VM -c "
    sudo apt update &&
    sudo apt install -y ansible &&
    ansible-playbook -i /vagrant/hosts /vagrant/playbook.yml
    "
done

echo "Playbook completed on both vms"

#This ssh into web and db and confirms ansible is present
vagrant ssh web -c "sudo systemctl status nginx"
vagrant ssh db -c "sudo systemctl status nginx"
