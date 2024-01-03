#!/bin/bash
toArray() {
  jq --raw-input | jq --compact-output --slurp '.'
}
setOutputVar() {
  echo "${1}=$2" | tee -a "$GITHUB_OUTPUT" &> /dev/null
}

if [ -z "$ccache_key" ]; then
  setOutputVar ccache_key "$default_ccache_key"
else
  setOutputVar ccache_key "$ccache_key"
fi

setOutputVar extra_flags "$(echo "$extra_flags" | toArray)"

src_path="$(realpath "$src_path")"
main="$(realpath "$main")"
main_path="${src_path}/${main}"

setOutputVar main_file "$(
  realpath \
    --canonicalize-missing \
    --relative-to="$GITHUB_WORKSPACE" \
    "${src_path}/${main}"
)"
