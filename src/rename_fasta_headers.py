#!/usr/bin/env python3

from Bio import SeqIO
import csv

# load files
transdecoder_results = 'output/transdecoder/Trinity.fasta.transdecoder.pep'
records = list(SeqIO.parse(transdecoder_results, 'fasta'))

# declare dictionaries
pepid_to_id = {}

# rename records, keep map of new id to old id
i = 0
for rec in records:
    i += 1
    # store old values in dictionaries
    pepid = 'PEP' + str(i)
    pepid_to_id[pepid] = rec.id

    # replace values and rename
    rec.id = pepid
    rec.name = ''
    rec.description = ''

# generating list of new id to old id
result_lines = list([x, pepid_to_id[x]]
                    for x in pepid_to_id.keys())

# write id mapping to file
header = ['pepid', 'id']
with open('output/signalp/ids.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=',')
    writer.writerow(header)
    writer.writerows(result_lines)

# write renamed fasta
SeqIO.write(
    sequences=records,
    handle='output/signalp/renamed_transdecoder_results.fasta',
    format='fasta')