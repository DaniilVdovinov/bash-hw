#!/bin/bash

let current_step=1
let hit_count=0
let miss_count=0
declare -a numbers

RED="\033[0;31m"
GREEN="\033[1;32m"
RESET="\033[0m"

function addNumberToStack {
  if [ "$2" -eq "1" ]; then
    number_string="${GREEN}$1${RESET}"
    else
    number_string="${RED}$1${RESET}"
  fi
  numbers+=("${number_string}")
}

function printHitMissPercent() {
    let total=$1+$2
    let hit_percent=$1*100/total
    let miss_percent=100-hit_percent

    echo "Hit: ${hit_percent}% Miss: ${miss_percent}%"
}

function checkInput {
    case "$1" in
        [0-9])
            return 0;
        ;;
        q)
            echo "Exiting..."
            exit 0;
        ;;
        *)
            return 1;
        ;;
    esac
}

function printLastNumbers {
    if [[ "$current_step" -lt 10 ]]; then
      echo -e $"${numbers[@]}"
    else
      echo -e $"${numbers[@]: -10}"
    fi
}


while true
do
  echo "Step $current_step"
  let random_number=${RANDOM: -1}

  read -p "Please enter number from 0 to 9 (q - quit):" input

  while ! checkInput "$input"
  do
    read -p "Invalid input. Try again:" input
  done

  if [ "${input}" == "${random_number}" ];
    then
      echo "Hit! My number: ${random_number}"
      let hit_count=hit_count+1
      addNumberToStack "$input" 1
    else
      echo "Miss! My number: ${random_number}"
      let miss_count=miss_count+1
      addNumberToStack "$input" 0
  fi
  printHitMissPercent "$hit_count" "$miss_count"
  printLastNumbers

  let current_step=current_step+1
done


