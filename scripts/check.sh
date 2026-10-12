#!/bin/zsh
set -euo pipefail
cd "${0:A:h}/.."
output=$(mktemp -d)
trap 'rm -rf "$output"' EXIT
swiftc Shared/CountdownModel.swift Tests/main.swift -o "$output/calendar-checks"
"$output/calendar-checks"
