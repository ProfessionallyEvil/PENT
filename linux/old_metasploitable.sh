#!/usr/bin/env bash

metasploitable_array=( "metasploitable1" "metasploitable2" )


for download in "${metasploitable_array[@]}" ; do

  pushd "${download}"
  current_download_link=$(cat link)
  metasploitable_zip_name="${download}.zip"
  metasploitable_file_dir="Metasploitable"
  wget -O "${metasploitable_zip_name}" "${current_download_link}"
  unzip "{metasploitable_zip_name}"
done
