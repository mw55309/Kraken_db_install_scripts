#!/usr/bin/env python

# usage:
#
# ./convert-ids.py < zcat *.fna.gz | gzip > reformatted.fna.gz
#

from Bio import SeqIO
import gzip
import sys

gi_to_taxid = {}

with gzip.open('gi_taxid_nucl.dmp.gz') as handle:
    for line in handle:
        gi, taxid = line.strip().split("\t")
        gi_to_taxid[gi] = taxid

with open('/dev/stdin') as handle:
    records = SeqIO.parse(handle, 'fasta')

    for n, record in enumerate(records):
        gid = record.id.split('|')[0]

        if gid in gi_to_taxid:
            record.id = gi_to_taxid[gid]
            print(record.format('fasta'))
        else:
            print("can't find GI {}. Aborting!".format(gid))
            quit(-1)
