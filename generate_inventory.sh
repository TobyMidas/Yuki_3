#!/bin/bash
vagrant up

#This extracts the IP addresses and stores as a variable
WEB_IP=$(vagrant ssh web -c 'hostname -I' | awk '{print $2}')
DB_IP=$(vagrant ssh db -c 'hostname -I' | awk '{print $2}')

# This sends all the ip addresses to a file names host
cat <<EOF > hosts
[web]
$WEB_IP ansible_user=vagrant

[db]
$DB_IP ansible_user=vagrant
EOF

echo "Inventory generated:"
cat hosts
echo "___________________________________---"

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
