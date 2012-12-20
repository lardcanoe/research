#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
 echo >&2 "Usage: $0 <group name> <deployment type>"
 exit 1
fi

if [ "$2" != "dev" ] && [ "$2" != "staging" ] && [ "$2" != "production" ];
then
 echo >&2 "Please specify a valid deployment type: dev, staging, or production."
 exit 1
fi

echo "Group Name: $1"
echo "Deployment Type: $2"

gname=$1
deployment=$2

ansible-playbook -i /etc/ansible/hosts ./playbooks/provision_instances.yml --extra-vars "grp_name=$gname deployment=$deployment"

./wait_for_instances.sh $gname

privkey="${HOME}/.ssh/$gname.pem"

ansible-playbook ./playbooks/create_tags.yml --private-key "$privkey" --extra-vars "grp_name=$gname deployment=$deployment"

ansible-playbook ./playbooks/app_setup.yml --private-key "$privkey" --extra-vars "grp_name=$gname deployment=$deployment"

ansible-playbook ./playbooks/db_setup.yml --private-key "$privkey" --extra-vars "grp_name=$gname deployment=$deployment"

ansible-playbook ./playbooks/myapp_setup.yml --private-key "$privkey" --extra-vars "grp_name=$gname deployment=$deployment"
