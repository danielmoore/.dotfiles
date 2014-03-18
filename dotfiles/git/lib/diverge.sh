#!/bin/bash

from=$1
if [[ -z $from ]]; then from="@{upstream}"; fi

to=$2
if [[ -z $to ]]; then to="HEAD"; fi

commits="$(git rev-list --left-right "$from"..."$to" 2>/dev/null)"
behind=0
ahead=0

for commit in $commits
do
  case "$commit" in
    "<"*) ((behind++)) ;;
    *)    ((ahead++))  ;;
  esac
done

if [[ $behind -eq 0 ]] && [[ $ahead -eq 0 ]]; then
  echo "u="
elif [[ $behind -eq 0 ]]; then
  echo "u+${ahead}" 
elif [[ $ahead -eq 0 ]]; then
  echo "u-${behind}"
else
  echo "u+${ahead}-${behind}"
fi
