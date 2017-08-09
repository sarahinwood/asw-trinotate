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
	"${transdecoder_results}"
	>"${outdir}/pfam.log"
