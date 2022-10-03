#!/bin/bash


function home_network() {
  ping -q -c 4 192.168.2.1 2>&1 >/dev/null
  return $?
}

function run_ansible() {
  export LC_ALL=en_US.UTF-8
  cd /home/asterr/zeus-ansible
  ansible-playbook /home/asterr/zeus-ansible/site.yml
}


# --------------------
# MAIN
# --------------------

if home_network ; then
  run_ansible
else
  echo "Not at home, skipping ansible"
  exit 0
fi
