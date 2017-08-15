#!/usr/bin/env bash

set -eu

bin_dir="$(readlink -f bin/trinotate/bin)"
export PATH="${bin_dir}:${PATH}"

trinity_fasta="data/Trinity.fasta"
blast_db="bin/trinotate/db/uniprot_sprot.pep"
hmmdb="bin/trinotate/trinotate/Pfam-A.hmm"

##check for transdecoder results
transdecoder_results="output/transdecoder/Trinity.fasta.transdecoder.pep"
if [[ ! -e "${transdecoder_results}" ]]; then
	src/run_transdecoder.sh "${trinity_fasta}" "${transdecoder_results}"
fi

##check for blastx results
blastx_results="output/blastx/blastx.outfmt6"
if [[ ! -e "${blastx_results}" ]]; then
	src/run_blastx.sh "${trinity_fasta}" "${blast_db}" "${blastx_results}"
fi

##check for blastp results
blastp_results="output/blastp/blastp.outfmt6"
if [[ -e "${transdecoder_results}" ]]; then
	if [[ ! -e "${blastp_results}" ]]; then
			src/run_blastp.sh "${transdecoder_results}" "${blast_db}" "${blastp_results}"
	fi
fi

##check for hmmer results
hmmer_results="output/hmmer/TrinotatePFAM.out"
if [[ -e "${transdecoder_results}" ]]; then
	if [[ ! -e "${hmmer_results}" ]]; then
		src/run_hmmer.sh "${transdecoder_results}" \
		"${hmmdb}" \
		"${hmmer_results}"
	fi
fi

##check for signalp results
signalp_results="output/signalp/signalp.out"
signalp_gff="output/signalp/signalp.gff"
if [[ -e "${transdecoder_results}" ]]; then
	if [[ ! -e "${signalp_results}" ]]; then
		src/run_signalp.sh \
		"${transdecoder_results}" \
		"${signalp_results}" \
		"${signalp_gff}"
	fi
fi

##check for tmhmm results
tmhmm_results="output/tmhmm/tmhmm.out"
if [[ -e "${transdecoder_results}" ]]; then
	if [[ ! -e "${tmhmm_results}" ]]; then
		src/run_tmhmm.sh \
		"${transdecoder_results}" \
		"${tmhmm_results}"
	fi
fi

##check for rnammer results
rnammer_results="output/rnammer/Trinity.fasta.rnammer.gff"
	if [[ ! -e "${rnammer_results}" ]]; then
		src/run_rnammer.sh \
		"${trinity_fasta}" \
		"${rnammer_results}"
	fi
	