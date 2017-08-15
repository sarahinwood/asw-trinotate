#!/usr/bin/env bash

set -eu

transdecoder_results="${1}"
signalp_results="${2}"
signalp_gff="${3}"

outdir="$(dirname "${signalp_results}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

signalp \
	-f short \
	-n "${signalp_gff}" \
	"${transdecoder_results}" \
	> "${signalp_results}"

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
signalp version, $(signalp -V)
_EOF_