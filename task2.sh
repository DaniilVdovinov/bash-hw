#!/bin/bash

while getopts "d:n:" opt; do
  case $opt in
    d)
      dir_path="$OPTARG"
      ;;
    n)
      name="$OPTARG"
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

if [[ -z "$dir_path" || -z "$name" ]]; then
  echo "Usage: $0 -d dir_path -n name"
  exit 1
fi

cat <<EOL > "$name"
#!/bin/bash

unpack_dir="."

while getopts "o:" opt; do
  case \$opt in
    o)
      unpack_dir="\$OPTARG"
      ;;
    \?)
      echo "Invalid option: -\$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -\$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

cat <<EOF | base64 --decode | tar -xzf - -C "\$unpack_dir"
EOL

tar -czf "$name.tar.gz" "$dir_path"
cat "$name.tar.gz" | base64 >> "$name"
echo "EOF" >> "$name"
chmod +x "$name"
rm "$name.tar.gz"

echo "Successfully created"
