#!/usr/bin/env bash

# https://blog.elreydetoda.site/cool-shell-tricks/#bashscriptingmodifiedscripthardening
set -${-//[sc]/}eu${DEBUG+xv}o pipefail


function main(){
  if [[ $# -ne 1 ]] ; then
    printf 'pass your api key as a parameter\n'
    return 1
  fi
  api_key="${1}"
  output_file="$( ansible-galaxy collection build --api-key "${api_key}" | cut -d ' ' -f 6- )"
  printf 'Is this the right path to the bundle?\n%s\n' "${output_file}"
  read -rn 1 upload_answer
  echo
  case "${upload_answer}" in
    Y|y)
      ansible-galaxy collection publish --api-key "${api_key}" "${output_file}"
      ;;
      *)
      echo "Didn't upload, because you said no..."
      return 0
  esac
}

# https://blog.elreydetoda.site/cool-shell-tricks/#bashscriptingbashsmain
if [[ "${0}" = "${BASH_SOURCE[0]}" ]] ; then
  main "${@}"
fi
