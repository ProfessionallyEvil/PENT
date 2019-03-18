#!/usr/bin/env bash

echo "What is your vagrant token?"
read VAGRANT_CLOUD_UPLOAD_TOKEN

echo "What verion is this for the boxes?"
read VAGRANT_BOX_VM_VERSION

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

pushd linux

time ./build.sh | tee build.log &

pushd metasploitable3

time ./build.sh ubuntu1404 | tee build.log &
time ./build.sh windows2008 | tee build.log &
