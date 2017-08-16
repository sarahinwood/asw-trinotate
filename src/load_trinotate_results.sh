#!/usr/bin/env bash

set -eu

trinity_fasta="${1}"
trinotate_database="${2}"
transdecoder_results="${3}"
blastx_results="${4}"
blastp_results="${5}"
hmmer_results="${6}"
signalp_gff="${7}"
tmhmm_results="${8}"
rnammer_results="${9}"

outdir="$(dirname "${trinotate_database}")"
if [[ ! -e "${outdir}" ]]; then
	mkdir -p "${outdir}"
fi

cp "$(readlink -f bin/trinotate/db/Trinotate.sqlite)" "${trinotate_database}"

##gene to trans map
trinity_gene_trans_map=output/trinotate/Trinity.fasta.gene_trans_map
get_Trinity_gene_to_trans_map.pl \
	"${trinity_fasta}" \
	>  "${trinity_gene_trans_map}"

##load info into trinotate.sqlite database
Trinotate \
	"${trinotate_database}" init \
	--gene_trans_map "${trinity_gene_trans_map}" \
	--transcript_fasta "${trinity_fasta}" \
	--transdecoder_pep "${transdecoder_results}"

##load transcript hits
Trinotate "${trinotate_database}" LOAD_swissprot_blastx "${blastx_results}"
##load protein hits
Trinotate "${trinotate_database}" LOAD_swissprot_blastp "${blastp_results}"
##load hmmer results
Trinotate "${trinotate_database}" LOAD_pfam "${hmmer_results}"
##load signalp results
Trinotate "${trinotate_database}" LOAD_signalp "${signalp_gff}"
##load tmhmm results
Trinotate "${trinotate_database}" LOAD_tmhmm "${tmhmm_results}"
##load rnammer results
Trinotate "${trinotate_database}" LOAD_rnammer "${rnammer_results}"

trinotate_report=output/trinotate/trinotate_annotation_report.xls
##output annotation report
Trinotate "${trinotate_database}" report [opts] > "${trinotate_report}"

cat <<- _EOF_ > "${outdir}/git.log"
branch,$(git rev-parse --abbrev-ref HEAD)
hash,$(git rev-parse HEAD)
signalp version, $(signalp -V)
_EOF_