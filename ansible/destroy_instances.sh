#!/bin/bash

if [[ -z "$1" ]]; then
	echo >&2 "Usage: $0 <group name>"
	exit 1
fi

ansible-playbook playbooks/terminate_instances.yml --extra-vars "grp_name=$1" -v

if [[ "$2" != "-s" ]]; then
	echo "Waiting 30s for instances to terminate..."
	sleep 30
fi

ansible-playbook -i /etc/ansible/hosts ./playbooks/destroy_instances.yml --extra-vars "grp_name=$1"
