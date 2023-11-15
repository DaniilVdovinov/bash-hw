#!/bin/bash

function print_desk() {
  local padding="  "
  echo "+-------------------+"
  for i in {0..3} ; do
    local line="|"
      for j in {0..3} ; do
        value=${numbers[i*4+j]}
        if [[ "${value}" == "$DEL" ]]; then
          value=" "
        fi
        line+=" $value${padding:${#value}} |"
      done
    echo "$line"
    if [[ i -ne 3 ]]; then echo "|-------------------|";fi
  done
  echo "+-------------------+"
}

function check_correct() {
    for i in {1..15} ; do
      if [[ "$i" != "${numbers[i-1]}" ]]; then
        return 1
      fi
    done
    return 0
}

function get_space_index() {
  get_index "$DEL"
}

function get_index() {
    for i in "${!numbers[@]}"; do
       if [[ "${numbers[$i]}" = "$1" ]]; then
           echo "${i}";
       fi
    done
}

function calc_available_numbers_to_move() {
    available_numbers=()

    let index=$(get_space_index);
    let row=$((index/4))
    let col=$((index%4))

    if [[ $row -eq 0 ]]; then
      available_numbers+=("${numbers[index+4]}")
    elif [[ $row -eq 3 ]]; then
      available_numbers+=("${numbers[index-4]}")
    else
      available_numbers+=("${numbers[index+4]}")
      available_numbers+=("${numbers[index-4]}")
    fi

    if [[ $col -eq 0 ]]; then
      available_numbers+=("${numbers[index+1]}")
    elif [[ $col -eq 3 ]]; then
      available_numbers+=("${numbers[index-1]}")
    else
      available_numbers+=("${numbers[index+1]}")
      available_numbers+=("${numbers[index-1]}")
    fi
}

function check_input {
  if [[ "$1" == "q" ]]; then
    echo "Выходим..."
    exit 0;
  else
    for i in "${!available_numbers[@]}"; do
       if [[ "${available_numbers[$i]}" = "$1" ]]; then
           return 0
       fi
    done
    return 1;
  fi

}

function swap_space() {
    space_index=$(get_space_index)
    number_index=$(get_index $1)
    numbers[space_index]=$1
    numbers[number_index]=$DEL
}


DEL="_"

declare -a numbers
for i in {1..15} ; do
    numbers+=("$i")
done
numbers+=("$DEL")

declare -a available_numbers

current_step=1
numbers=($(shuf -e "${numbers[@]}"))

clear -x
while true
do
  echo "Ход № $current_step"
  print_desk
  read -p "Ваш ход (q - выход):" input

  calc_available_numbers_to_move

  while ! check_input "$input"
  do
    echo "Неверный ход!"
    echo "Невозможно костяшку $input передвинуть на пустую ячейку."
    echo "Можно выбрать: ${available_numbers[*]}"
    read -p "Ваш ход (q - выход):" input
  done
  clear -x

  swap_space "$input"
  if check_correct; then
    echo "Поздравляем! Вы собрали головоломку за $current_step ходов"
    print_desk
    exit 0;
  fi
  current_step=$((current_step+1))

done



