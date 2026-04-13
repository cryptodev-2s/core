#!/usr/bin/env bash

set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Missing package name."
  exit 1
fi

package_name="$1"
shift  # remove package name from arguments

# Enable --checkDeps only on non-main branches to avoid
# "HEAD is the same as the base branch" errors on main.
branch=$(git rev-parse --abbrev-ref HEAD)
check_deps_args=()
if [[ "$branch" != "main" && "$branch" != "HEAD" ]]; then
  check_deps_args=(--checkDeps)
fi

if [[ "${GITHUB_REF:-}" =~ '^release/' ]]; then
  yarn auto-changelog validate --prettier --tag-prefix "${package_name}@" --rc "${check_deps_args[@]+"${check_deps_args[@]}"}" "$@"
else
  yarn auto-changelog validate --prettier --tag-prefix "${package_name}@" "${check_deps_args[@]+"${check_deps_args[@]}"}" "$@"
fi
