#!/usr/bin/env bash

set -eu

trinity_fasta="${1}"
blast_db="${2}"
blastx_results="${3}"


outdir="$(dirname "${blastx_results}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

blastx \
	-query "${trinity_fasta}" \
	-db "${blast_db}" \
	-num_threads 50 \
	-max_target_seqs 1 \
	-outfmt 6 > "${blastx_results}" \
	2> "${outdir}/blastx.err"

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
_EOF_