#!/usr/bin/env bash

for i in $(grep define Vagrantfile | cut -d '"' -f 2) ;
	do vagrant up $i
done
