#!/usr/bin/env bash

set -eu

transdecoder_results="${1}"
hmmdb="${2}"
hmmer_results="${3}"

outdir="$(dirname "${hmmer_results}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

hmmscan \
	--cpu 50 \
	--domtblout "${hmmer_results}" \
	"${hmmdb}" \
	"${transdecoder_results}" \
	>"${outdir}/pfam.log"

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
signalp version, $(signalp -V)
_EOF_