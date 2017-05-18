# Kraken_db_install_scripts

Updated Kraken DB install scripts to cope with new-ish NCBI structure

## Dependencies

* [Kraken](https://github.com/DerrickWood/kraken) installed and in your $PATH
* [bioperl](http://bioperl.org)

## Usage

Usage is very similar to [adding a custom database](http://ccb.jhu.edu/software/kraken/MANUAL.html#custom-databases)
as explained in the Kraken manual.

First, download the taxonomy:

```shell
DB_NAME="kraken_db"
kraken_shell_scripts/kraken-build --download-taxonomy --db $DB_NAME
```

This step will download taxonomy tree info and the GI to taxid mapping file.
Since we're manually adding a new library, the GI's will not be used, and the accessions numbers will be mapped to the taxids at the next steps
  

Then, download the genomes you want to add the your kraken database. With the
perl scripts from this directory, you can download:

* complete genomes from refseq:
    * archaeal genomes
    * bacterial genomes
    * fungal genomes
    * protozoan genomes
    * viral genomes

* Homo_sapiens.GRCh38 (primary assembly)


If you want to install the complete viral genomes from RefSeq, per example:

```shell
perl download_viral.pl
find viral/ -name '*.fna' -print0 | \
    xargs -0 -I{} -n1 kraken_shell_scripts/kraken-build \
    --add-to-library {} --db $DB_NAME
kraken_shell_scripts/kraken-build --build --db $DB_NAME
```

## License

The scripts under `kraken_shell_scripts` are
[GPL3](kraken_shell_scripts/LICENSE.txt)  
The rest is [MIT](LICENSE.txt)
