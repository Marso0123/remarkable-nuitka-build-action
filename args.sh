#!/bin/bash
toArray() {
  jq --raw-input | jq --compact-output --slurp '.'
}
setOutputVar() {
  echo "${1}=$2" | tee -a "$GITHUB_OUTPUT" &> /dev/null
}

# Validate GITHUB_* variables that are used
if [ -z "$GITHUB_WORKSPACE" ]; then
  echo "GITHUB_WORKSPACE is missing"
  exit 1
fi
if ! [ -d "$GITHUB_WORKSPACE" ]; then
  echo "${GITHUB_WORKSPACE} does not exist"
  exit 1
fi
if ! [ -f "$GITHUB_OUTPUT" ]; then
  echo "${GITHUB_OUTPUT} does not exist"
  exit 1
fi
if [ -z "$GITHUB_OUTPUT" ]; then
  echo "GITHUB_OUTPUT is missing"
  exit 1
fi

if [ -z "$ccache_key" ]; then
  setOutputVar ccache_key "$default_ccache_key"
else
  setOutputVar ccache_key "$ccache_key"
fi

setOutputVar extra_flags "$(echo "$extra_flags" | toArray)"

if ! [ -d "$src_path" ]; then
  echo "${src_path} does not exist"
  exit 1
fi
src_path="$(realpath --canonicalize-missing "$src_path")"
cd "$src_path"
if [ -f "$main" ] || [ -d "$main" ]; then
  main="$(
    realpath \
      --relative-to="$src_path" \
      "$main"
  )"
else
  echo "${main} does not exist"
  exit 1
fi
main="$(realpath "${src_path}/${main}")"

setOutputVar main_file "$(
  realpath \
    --canonicalize-missing \
    --relative-to="$GITHUB_WORKSPACE" \
    "$main"
)"
