#!/usr/bin/perl

use File::Basename;
use Bio::SeqIO;
use Bio::PrimarySeq;

# the human fa to download
# note this is just the core assembly, no alts
my $fa = "ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz";

# get the assembly file
system("wget -q $fa") == 0
    or die "failed: $?";

# open the file
my $fname = basename($fa);
open(IN, "zcat $fname |");
my $in = Bio::SeqIO->new(-fh => \*IN, -format => 'fasta');

# open output - sorry about the hardcoded name!
my $out = Bio::SeqIO->new(-file => ">human_genomic.tax.fna", -format => 'fasta');

# iterate over sequences
while(my $seq = $in->next_seq()) {

	# add kraken:taxid to the unique ID
	my $id = $seq->primary_id;
	$id = $id . '|' . "kraken:taxid" . '|' . "9606";
	
	print "Processed $id\n";
	
	# create new seq object with updated ID
	my $newseq = Bio::PrimarySeq->new(-id => $id, -seq => $seq->seq, -desc => $seq->description);

	# write it out
	$out->write_seq($newseq);
}

close IN;
