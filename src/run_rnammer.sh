#!/usr/bin/env bash

set -eu

trinity_fasta="$(readlink -f "${1}")"
rnammer_results="${2}"

outdir="$(dirname "${rnammer_results}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

(
cd "${outdir}" || exit 1
cp "${trinity_fasta}" ./Trinity.fasta
	RnammerTranscriptome.pl \
	--transcriptome Trinity.fasta \
	--path_to_rnammer "$(which rnammer)"
	)

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
_EOF_