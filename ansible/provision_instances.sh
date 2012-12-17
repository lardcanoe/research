#!/bin/bash

if [[ -z "$1" ]]; then
 echo >&2 "Please specify a name for the new group."
 exit 1
fi

ansible-playbook -i /etc/ansible/hosts ./playbooks/provision_instances.yml --extra-vars "grp_name=$1"

./wait_for_instances.sh $1

privkey="${HOME}/.ssh/$1.pem"

ansible-playbook ./playbooks/create_tags.yml --private-key "$privkey" --extra-vars "grp_name=$1"

ansible-playbook ./playbooks/app_setup.yml --private-key "$privkey" --extra-vars "grp_name=$1"

ansible-playbook ./playbooks/db_setup.yml --private-key "$privkey" --extra-vars "grp_name=$1"
