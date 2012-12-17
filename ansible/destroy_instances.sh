#!/bin/bash

if [[ -z "$1" ]]; then
 echo >&2 "Please specify a name for the group."
 exit 1
fi

ansible-playbook playbooks/terminate_instances.yml --extra-vars "grp_name=$1" -v

echo "Waiting 30s for instances to terminate..."
sleep 30

ansible-playbook -i /etc/ansible/hosts ./playbooks/destroy_instances.yml --extra-vars "grp_name=$1"
