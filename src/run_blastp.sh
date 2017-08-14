#!/usr/bin/env bash

set -eu

transdecoder_results="${1}"
blast_db="${2}"
blastp_results="${3}"

outdir="$(dirname "${blastp_results}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

blastp \
	-query "${transdecoder_results}" \
	-db "${blast_db}" \
	-num_threads 50 \
	-max_target_seqs 1 \
	-outfmt 6 > "${blastp_results}"

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
_EOF_