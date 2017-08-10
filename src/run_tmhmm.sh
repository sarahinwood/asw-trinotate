#!/usr/bin/env bash

set -eu

tmhmm_path="$(readlink -f "$(which tmhmm)")"

transdecoder_results="${1}"
tmhmm_results="${2}"

outdir="$(dirname "${tmhmm_results}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

"${tmhmm_path}" \
	--short \
	< "${transdecoder_results}" \
	> "${tmhmm_results}" \
	2> "${outdir}/tmhmm.err"

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
_EOF_
