#!/bin/bash

init="${1:-false}"
file="$HOME/.config/hypr/current_layout"

set_default() {
  if [[ -z $HYPR_DEFAULT_LAYOUT ]]; then
    printf "\nExpect \$HYPR_DEFAULT_LAYOUT env var to be declare with a non-empty value\n"
    exit 1
  fi

  echo "$HYPR_DEFAULT_LAYOUT" > "$file"
}

if [[ $init == true ]]; then
  set_default
  exit 0
fi

if ! [[ -s "$file" ]]; then 
  set_default
fi

layouts=()

while IFS= read -r line; do
  if [[ -n $line ]]; then
    layouts+=("$line")
  fi
done < <(hyprctl layouts)

len=${#layouts[@]}
current_layout=$(cat "$file")

get_next_layout() {

  for (( i = 0; i < len; i++ )); do
    if [[ "${layouts[$i]}" = "${current_layout}" ]]; then
      next=${layouts[((i + 1))]}

      if [[ $next == "" ]]; then
        echo "${layouts[0]}"
        break
      fi

      echo "${layouts[((i + 1))]}"
      break
    fi
  done
}

echo "Previous layout: $current_layout"

next_layout=$(get_next_layout)
hyprctl keyword general:layout "$next_layout"
echo "$next_layout" > "$file"

echo "Next layout: $next_layout"

