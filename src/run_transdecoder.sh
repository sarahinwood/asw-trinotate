#!/usr/bin/env bash

set -eu

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
cp "${trinity_fasta}" ./Trinity.fasta
TransDecoder.LongOrfs -t Trinity.fasta -S
TransDecoder.Predict -t Trinity.fasta
	)

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
_EOF_