#!/usr/bin/env bash

## transdecoder requires perl library db_file, install with perl -MCPAN -e
## shell; install DB_File

set -eu

td_longorfs="$(readlink -f bin/trinotate/transdecoder/TransDecoder.LongOrfs)"
td_predict="$(readlink -f bin/trinotate/transdecoder/TransDecoder.Predict)"

trinity_fasta="$(readlink -f "${1}")"
transdecoder_results="${2}"

printf "trinity_fasta: %s\n" "${trinity_fasta}"
printf "transdecoder_results: %s\n" "${transdecoder_results}"

outdir="$(dirname "${transdecoder_results}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

(
cd "${outdir}" || exit 1
"${td_longorfs}" -t "${trinity_fasta}" -S
"${td_predict}" -t "${trinity_fasta}"
	)
