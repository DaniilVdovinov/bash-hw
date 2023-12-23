#!/bin/bash

if [ -z "$1" ];then
	echo "Empty list of options. Requires options -p" >&2
	exit 1
fi

while getopts ":p:" opt; do
  case $opt in
    p)
      path="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ ! -d "$path" ]; then
  echo "Path $path is not directory"
  exit 1
fi

prependline="Approved $(whoami) $(date -Iseconds)"

for filepath in "$path"/*.txt; do
  printf '%s\n%s\n' "$prependline" "$(cat "$filepath")" > "$filepath"
done




