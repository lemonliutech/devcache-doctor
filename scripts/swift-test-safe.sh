#!/bin/zsh
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd -P)"

cleanup_stale_swiftpm() {
  local killed_any=0
  while IFS= read -r line; do
    local pid="${line%% *}"
    local cmd="${line#* }"

    case "$cmd" in
      *"$repo_root/.build"*DevStorageDoctorPackageTests.xctest*|*swift-test*" $repo_root"*)
        kill "$pid" 2>/dev/null || true
        killed_any=1
        ;;
    esac
  done < <(ps -axo pid=,command=)

  if [[ "$killed_any" -eq 1 ]]; then
    sleep 1
  fi
}

cleanup_stale_swiftpm

swift test "$@"
