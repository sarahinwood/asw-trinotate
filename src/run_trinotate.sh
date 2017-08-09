#!/usr/bin/env bash

set -eu

trinity_fasta="data/Trinity.fasta"
hmmdb="bin/trinotate/trinotate/Pfam-A.hmm"

##check for blastx results


##check for transdecoder results
transdecoder_results="output/transdecoder/Trinity.fasta.transdecoder.pep"
if [[ ! -e "${transdecoder_results}" ]]; then
	src/run_transdecoder.sh "${trinity_fasta}" "${transdecoder_results}"
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

##check for tmhmm results

##check for rnammer results