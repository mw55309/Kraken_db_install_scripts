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
        row = line.strip().split("\t")
        gi, taxid = int(row[0]), int(row[1])
        gi_to_taxid[gi] = taxid

with open('/dev/stdin') as handle:
    records = SeqIO.parse(handle, 'fasta')

    for n, record in enumerate(records):
        gid = int(record.id.split('|')[1])

        # $id = $id . '|' . "kraken:taxid" . '|' . $taxid;

        if gid in gi_to_taxid:
            new_id = '{}|kraken:taxid|{}'.format(gid, gi_to_taxid[gid])
            record.id = new_id
            print(record.format('fasta'))
        else:
            print("can't find GI {}. Aborting!".format(gid))
            quit(-1