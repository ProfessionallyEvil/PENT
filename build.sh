#!/usr/bin/env bash

echo "What is your vagrant token?"
read vagrant_cloud_token

echo "What verion is this for the boxes?"
read vm_version

echo "Should this be headless [Y/n]"
read headless

if [[ -z $headless ]] ; then
  headless=true
else
  headless=''
fi

export VAGRANT_CLOUD_UPLOAD_TOKEN="${VAGRANT_CLOUD_UPLOAD_TOKEN}"
export VAGRANT_BOX_VM_VERSION="${VAGRANT_BOX_VM_VERSION}"
export HEADLESS="$headless"

printf '{"vm_version":"%s","vagrant_cloud_token":"%s"}\n' "$vm_version" "$vagrant_cloud_token" | jq . | tee variables.json

variable_file=$(readlink -f variables.json)
export variable_file="${2}"

pushd linux

time ./build.sh $variable_file | tee build.log &

pushd metasploitable3

time ./build.sh ubuntu1404 $variable_file | tee build.log
time ./build.sh windows2008 $variable_file | tee build.log
