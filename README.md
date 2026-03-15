# To Run
Clone Repo
chmod +x generate_iventory.sh
./generate_inventory.sh
(Run this in git bash as it's a windows system)
(If unix, you can run normally in cd)

#Errors Faced
1. Ansible not found
- Resolved by adding that in the sh file

2. SSH Permission Denied
- I used ansible_user=vagrant because i was running on git bash

3. Hostname -I no output
- I resolved this by starting the vagrant machine from the bash script

4. Inventory Confusion
- Resolved this by adding connection local in the yml file so it runs on the server and not both
Previous Code-
vagrant ssh web -c "
sudo apt update &&
sudo apt install -y ansible &&
ansible-playbook -i /vagrant/hosts /vagrant/playbook.yml
"
Updated -
for VM in web db; do
    echo "Running playbook on $VM"
    vagrant ssh $VM -c "
    sudo apt update &&
    sudo apt install -y ansible &&
    ansible-playbook -i /vagrant/hosts /vagrant/playbook.yml
    "
done
- This runs the script in each host individually  without ssh
