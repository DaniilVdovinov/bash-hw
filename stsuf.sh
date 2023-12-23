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

declare -A stat_map

while read -r -d '' filepath; do
  filename=$(basename "$filepath")
  suffix="${filename##*.}"
  if [[ "$filename" == "$suffix" ]]; then
    ((stat_map["no_suffix"]++))
  else
    ((stat_map[".$suffix"]++))
  fi
done < <(find "$path" -type f -print0)

for k in "${!stat_map[@]}"; do
    echo "$k: ${stat_map["$k"]}"
done | sort -rn -k2 | cat

