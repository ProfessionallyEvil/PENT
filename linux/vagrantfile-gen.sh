#!/usr/bin/env bash

set -ex

packer_dir='./packer'
vagrantfiles_dir="${packer_dir}/vagrant_files"
vagrantfile_template="${packer_dir}/old_metasploitable.vagrant"
PUBLIC_SUBNET='10.42.100'
starting_IP=20

# making a backup
cp ${vagrantfile_template}.orig ${vagrantfile_template}

# setting public subnet variable in vagrant template
sed -i "s/PUBLIC_SUBNET/${PUBLIC_SUBNET}/" $vagrantfile_template

# copying for each vm
for vagrantfile in $(find ./ -maxdepth 1 -type d | grep -vE '^./$|^./packer' | tr -d '[:punct:]' | sed 's/vulnweb/vuln_web/') ; do
  cp ${vagrantfile_template} ${vagrantfiles_dir}/${vagrantfile}.vagrant
done

PUBLIC_LAST_OCTET="${starting_IP}"
# customizing to individual needs
for vagrantfile in $(ls ${vagrantfiles_dir} | cut -d '.' -f 1) ; do
  case ${vagrantfile} in
    metasploitable1)
      SSH_USERNAME='msfadmin'
      ;;
    metasploitable2)
      SSH_USERNAME='msfadmin'
      ;;
    metasploitable3)
      SSH_USERNAME='vagrant'
      ;;
    vuln_web)
      SSH_USERNAME='vagrant'
      ;;
  esac
  sed -i "s/PUBLIC_LAST_OCTET/${PUBLIC_LAST_OCTET}/" "${vagrantfiles_dir}/${vagrantfile}.vagrant"
  sed -i "s/SSH_USERNAME/${SSH_USERNAME}/" "${vagrantfiles_dir}/${vagrantfile}.vagrant"
  PUBLIC_LAST_OCTET=$(( $PUBLIC_LAST_OCTET + 1 ))
done

# doing metasploitable3 windows vagrant template
appended_text=$(grep -P '^ ' ${vagrantfile_template} | sed ':a;N;$!ba;s/\n/\\n/g')
metasploitable3_windows_vagrantfile='metasploitable3/packer/templates/vagrantfile-windows_2008_r2.template'
SSH_USERNAME='vagrant'

cp ${metasploitable3_windows_vagrantfile}.orig ${metasploitable3_windows_vagrantfile}
sed -i "s/^end/${appended_text}\\nend/" ${metasploitable3_windows_vagrantfile}
sed -i "s/PUBLIC_LAST_OCTET/${PUBLIC_LAST_OCTET}/" "${metasploitable3_windows_vagrantfile}"
sed -i "s/SSH_USERNAME/${SSH_USERNAME}/" "${metasploitable3_windows_vagrantfile}"

PUBLIC_LAST_OCTET=$(( $PUBLIC_LAST_OCTET + 1 ))
