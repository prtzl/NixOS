#!/usr/bin/env bash

set -eo pipefail

pattern=${1:-""}
fd "$pattern" "${@:2}" --color always | rg --color=always --passthrough "$pattern"
