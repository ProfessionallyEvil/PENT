#!/usr/bin/env bash

set -e

metasploitable_array=( "metasploitable1" "metasploitable2" )
# handle vagrant and packer pre-reqs with metsaploitable3's scripts
package_reqs=( "bash" "ps" "grep" "bsdtar" "curl" "sed" )

cleanup(){
  if [[ -f output-virtualbox-ovf/ ]] ; then
    rm -rf output-virtualbox-ovf/
  fi
  for folder in "${metasploitable_array[@]}" ; do
    ./vmx-vbox.sh ${folder}
    pushd ${folder}
    rm -rf "${folder}_vm"
    rm *.box
    popd
  done
  
}


download(){
  echo -e "Please don't touch the terminal, it might look like it is hung, but it is mostlikely downloading still, it should continue when done downloading\n"

  for download in "${metasploitable_array[@]}" ; do
  
    pushd "${download}" 1> /dev/null
    current_download_link=$(cat link)
    metasploitable_zip_name="${download}.zip"
    metasploitable_folder="${download}_vm"
    mkdir -p "${metasploitable_folder}" 1> /dev/null
    curl -sSL "${current_download_link}" | bsdtar -xvf - --strip-components=1  -C "${metasploitable_folder}" 1> /dev/null &
    popd 1> /dev/null

  done

  # waiting till done downloading files
  while ps -aux | grep "${USER}" | grep '[c]url' 1> /dev/null ; do
    sleep 1
  done

  slight_tweaks
}

slight_tweaks(){
  sed -i 's/ethernet0.connectionType = "bridged"/ethernet0.connectionType = "nat"/' metasploitable1/metasploitable1_vm/Metasploitable.vmx

}

vbox_conversion(){
  vm="${1}"
  metasploitable_folder="${vm}_vm"
  ./vmx-vbox.sh ${vm} "${vm}/${metasploitable_folder}/Metasploitable.vmdk"
}

build(){
  vm="${1}"
  packer build -var "headless_bool=true" -var "current_metasploit=${vm}" -var "vmware_source_path=${vm}/${vm}_vm/Metasploitable.vmx" -var "vbox_source_path=./${vm}-vbox.ova" packer/old_metasploitable.json
}

main(){

  download
  for vm in "${metasploitable_array[@]}" ; do
    vbox_conversion ${vm}
    build ${vm}
  done
  echo "ready?"
  read y
  cleanup
}

main
