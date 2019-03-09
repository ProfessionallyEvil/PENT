#!/usr/bin/env bash

dependencies=( "libncursesw5" )

out_file='vmware.x86_64.bundle'
download_link='https://www.vmware.com/go/getworkstation-linux'
wget -O ${out_file} ${download_link}

sudo bash ${out_file} --console --eulas-agreed --required
