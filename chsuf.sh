#!/bin/bash


if [ -z "$1" ];then
	echo "Empty list of options. Requires options -p -o -n" >&2
	exit 1
fi

while getopts ":p:o:n:" opt; do
  case $opt in
    p)
      path="$OPTARG"
      ;;
    o)
      oldsuf="$OPTARG"
      ;;
    n)
      newsuf="$OPTARG"
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

if [[ -z "$path" || -z "$oldsuf" || -z "$newsuf" ]]; then
  echo "Usage: $0 -p dir_path -o old_suffix -n new_suffix"
  exit 1
fi

if [[ "$oldsuf" != "."* || "$oldsuf" == "."*"."* ]]; then
    echo "Incorrect suffix $oldsuf"
    exit 1
fi

if [[ "$newsuf" != "."* || "$newsuf" == "."*"."* ]]; then
    echo "Incorrect suffix $newsuf"
    exit 1
fi

find "$path" -type f -name "*$oldsuf" -print0 | while read -r -d '' filepath; do
  filename=$(basename "$filepath" "$oldsuf")
  if [[ "$filename" != "$oldsuf" ]]; then
    mv -- "$filepath" "${filepath%$oldsuf}$newsuf"
  fi
done;

