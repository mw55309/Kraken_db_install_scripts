#!/bin/bash

# Copyright 2013-2015, Derrick Wood <dwood@cs.jhu.edu>
#
# This file is part of the Kraken taxonomic sequence classification system.
#
# Kraken is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Kraken is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Kraken.  If not, see <http://www.gnu.org/licenses/>.

# Download specific genomic libraries for use with Kraken.
# Supported choices are:
#   bacteria - NCBI RefSeq complete bacterial/archaeal genomes
#   plasmids - NCBI RefSeq plasmid sequences
#   viruses - NCBI RefSeq complete viral DNA and RNA genomes
#   human - NCBI RefSeq GRCh38 human reference genome

set -u  # Protect against uninitialized vars.
set -e  # Stop on error

LIBRARY_DIR="$KRAKEN_DB_NAME/library"
NCBI_SERVER="ftp.ncbi.nih.gov"
FTP_SERVER="ftp://$NCBI_SERVER"
RSYNC_SERVER="rsync://$NCBI_SERVER"
THIS_DIR=$PWD

case "$1" in
  "fungi")
    mkdir -p $LIBRARY_DIR/Fungi
    cd $LIBRARY_DIR/Fungi
    if [ ! -e "lib.complete" ]
    then
      wget $FTP_SERVER/refseq/release/fungi/*.genomic.fna.gz
      echo -n "Unpacking..."
      gunzip *.genomic.fna.gz
      echo " complete."
      touch "lib.complete"
    else
      echo "Skipping download of fungal genomes, already downloaded here."
    fi
    ;;
  "archaea")
    mkdir -p $LIBRARY_DIR/Archaea
    cd $LIBRARY_DIR/Archaea
    if [ ! -e "lib.complete" ]
    then
      wget $FTP_SERVER/refseq/release/archaea/*.genomic.fna.gz
      echo -n "Unpacking..."
      gunzip *.genomic.fna.gz
      echo " complete."
      touch "lib.complete"
    else
      echo "Skipping download of archaeal genomes, already downloaded here."
    fi
    ;;
  "bacteria")
    mkdir -p $LIBRARY_DIR/Bacteria
    cd $LIBRARY_DIR/Bacteria
    if [ ! -e "lib.complete" ]
    then
      wget $FTP_SERVER/refseq/release/bacteria/*.genomic.fna.gz
      echo -n "Unpacking..."
      gunzip *.genomic.fna.gz
      echo " complete."
      touch "lib.complete"
    else
      echo "Skipping download of bacterial genomes, already downloaded here."
    fi
    ;;
  "plasmids")
    mkdir -p $LIBRARY_DIR/Plasmids
    cd $LIBRARY_DIR/Plasmids
    if [ ! -e "lib.complete" ]
    then
      wget $FTP_SERVER/refseq/release/plasmid/*.genomic.fna.gz
      echo -n "Unpacking..."
      gunzip *.genomic.fna.gz
      echo " complete."
      touch "lib.complete"
    else
      echo "Skipping download of plasmids, already downloaded here."
    fi
    ;;
  "viruses")
    mkdir -p $LIBRARY_DIR/Viruses
    cd $LIBRARY_DIR/Viruses
    if [ ! -e "lib.complete" ]
    then
      wget $FTP_SERVER/refseq/release/viral/*.genomic.fna.gz
      echo -n "Unpacking..."
      gunzip *.genomic.fna.gz
      echo " complete."
      touch "lib.complete"
    else
      echo "Skipping download of viral genomes, already downloaded here."
    fi
    ;;
  "human")
    mkdir -p $LIBRARY_DIR/Human
    cd $LIBRARY_DIR/Human
    if [ ! -e "lib.complete" ]
    then
      # get list of CHR_* directories
      wget --spider --no-remove-listing $FTP_SERVER/genomes/H_sapiens/
      directories=$(perl -nle '/^d/ and /(CHR_\w+)\s*$/ and print $1' .listing)
      rm .listing

      # For each CHR_* directory, get GRCh* fasta gzip file name, d/l, unzip, and add
      for directory in $directories
      do
        wget --spider --no-remove-listing $FTP_SERVER/genomes/H_sapiens/$directory/
        file=$(perl -nle '/^-/ and /\b(hs_ref_GRCh\w+\.fa\.gz)\s*$/ and print $1' .listing)
        [ -z "$file" ] && exit 1
        rm .listing
        wget $FTP_SERVER/genomes/H_sapiens/$directory/$file
        gunzip "$file"
      done

      touch "lib.complete"
    else
      echo "Skipping download of human genome, already downloaded here."
    fi
    ;;
  *)
    echo "Unsupported library.  Valid options are: "
    echo "  bacteria plasmids virus human"
    ;;
esac
