#!/bin/bash

# Usage example ./task4.sh --number 4 --mask 'task*' ./command.sh

dirpath="."
mask="*"
number=$(nproc)

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --path)
      dirpath="$2"
      shift
      shift
      ;;
    --mask)
      mask="$2"
      shift
      shift
      ;;
    --number)
      number="$2"
      shift
      shift
      ;;
    *)
      command="$1"
      shift
      ;;
  esac
done

if [ -z "$command" ]; then
  echo "Не указан путь до скрипта"
  exit 1
fi

if [ ! -f "$command" ] && ! command -v $command > /dev/null; then
  echo "Команда не найдена: $command"
  exit 1
fi

if [ ! -x "$command" ] && [ ! -x "$(command -v "$command")" ]; then
  echo "Скрипт $command не исполняемый"
  exit 1
fi

files=($dirpath/$mask)

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    # Используем принцип синхронизации - Semaphore
    $command "$file" &
    ((running++))
    if [ $running -ge $number ]; then
      wait
      ((running--))
    fi
  fi
done

wait
