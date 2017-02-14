#!/usr/bin/env python

#
# usage:
#
# ./convert-ids.py < zcat *.fna.gz | gzip > reformatted.fna.gz
#
# warning! will consume a fuckton of memory
#

from Bio import SeqIO
from peewee import *

db = PostgresqlDatabase('gi_taxids')

class GiTaxid(Model):
    gi = IntegerField()
    taxid = IntegerField()


    class Meta:
        database = db
        db_table = 'gi_taxids'
        primary_key = False

db.connect()

BATCH_SIZE=1000

def get_taxids(gids):
    gi_taxids = GiTaxid.select().where(GiTaxid.gi << gids)
    return { gi_taxid.gi: gi_taxid.taxid for gi_taxid in gi_taxids }

with open('/dev/stdin') as handle:
    records = SeqIO.parse(handle, 'fasta')

    gi_batch, record_batch = [], []

    for record in records:
        gid = int(record.id.split('|')[1])

        gi_batch.append(gid)
        record_batch.append(record)

        if len(gi_batch) % BATCH_SIZE == 0:
            taxids = get_taxids(gi_batch)

            for record in record_batch:
                gid = int(record.id.split('|')[1])
                new_id = '{}|kraken:taxid|{}'.format(gid, taxids[gid])
                record.id = new_id
                # no longer need this so strip it to save space
                record.description = ''
                print(record.format('fasta'))

            gi_batch, record_batch = [], []


taxids = get_taxids(gi_batch)

for record in record_batch:
    gid = int(record.id.split('|')[1])
    new_id = '{}|kraken:taxid|{}'.format(gid, taxids[gid])
    record.id = new_id
    # no longer need this so strip it to save space
    record.description = ''
    print(record.format('fasta'))
