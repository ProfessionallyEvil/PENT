#!/usr/bin/env bash

vagrant up
sleep 3
vagrant halt
vagrant package --base $(vboxmanage list vms | grep $(cat .vagrant/machines/default/virtualbox/id) | tr -d '"|{|}' | cut -d ' ' -f 1) --output vuln_web.box

# tmp for testing
vagrant box add --name PENT/vuln_web ./vuln_web.box
