#!/bin/bash

filter="key_$1"
privkey="${HOME}/.ssh/$1.pem"

while :
do

  ansible $filter -m ping -u ubuntu --private-key "$privkey" > /dev/null 2>&1
  retval=$?

  if [ $retval -eq 0 ]
  then
    break
  fi

  echo "Waiting for servers to boot..."
  sleep 5

done
