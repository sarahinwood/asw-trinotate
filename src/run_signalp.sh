#!/usr/bin/env bash

set -eu

transdecoder_results="${1}"
signalp_results="${2}"

outdir="$(dirname "${signalp_results}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

signalp \
	-f short \
	-n "${signalp_results}" \
	"${transdecoder_results}"

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
_EOF_
