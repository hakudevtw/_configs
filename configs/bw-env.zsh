# bw-env: load the Bitwarden folder "env" into THIS terminal session.
# Each item in the folder is one variable: item name = variable name, password field = value.
# Nothing is written to disk and values are never printed; closing the window drops them.
# Sourced from configs/zshrc.

bw-env() {
  command -v bw >/dev/null 2>&1 || { echo "bw not found (brew install bitwarden-cli)" >&2; return 1; }
  command -v jq >/dev/null 2>&1 || { echo "jq not found (brew install jq)" >&2; return 1; }

  local state
  state="$(bw status 2>/dev/null | jq -r '.status // "unauthenticated"')"
  case "$state" in
    unauthenticated) BW_SESSION="$(bw login --raw)" || return 1 ;;
    unlocked) [ -n "$BW_SESSION" ] || BW_SESSION="$(bw unlock --raw)" || return 1 ;;
    *) BW_SESSION="$(bw unlock --raw)" || return 1 ;;
  esac
  export BW_SESSION

  bw sync >/dev/null 2>&1

  local folder_id
  folder_id="$(bw list folders 2>/dev/null | jq -r '.[] | select(.name == "env") | .id' | head -1)"
  if [ -z "$folder_id" ]; then
    echo "No Bitwarden folder named 'env'. Create it in the app and add one item per variable." >&2
    return 1
  fi

  local name value loaded=()
  while IFS=$'\t' read -r name value; do
    if [[ ! "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
      echo "skipped '$name': not a valid variable name" >&2
      continue
    fi
    export "$name=$value"
    loaded+=("$name")
  done < <(bw list items --folderid "$folder_id" 2>/dev/null \
    | jq -r '.[] | select(.login.password != null) | "\(.name)\t\(.login.password)"')

  if [ ${#loaded[@]} -eq 0 ]; then
    echo "The 'env' folder has no items with a password yet." >&2
    return 1
  fi
  echo "Loaded: ${loaded[*]}"
}
