set -euo pipefail

databases=(
Zea_mays
archaea
bacteria
fungi
human
protozoa
viral
)

for database in "${databases[@]}"; do
  echo "----> downloading ${database}"
  perl download_${database}.pl
done

mkdir human
mv *.tax.fna human/

/kraken/kraken-build \
  --download-taxonomy \
  --db krakendb

for database in "${databases[@]}"; do
  for fna in ${database}/*.tax.fna; do
    /kraken/kraken-build \
      --add-to-library ${fna} \
      --db krakendb

    # remove original fasta file to save space
    rm ${fna}
  done
done

/kraken/kraken-build \
  --build \
  --max-db-size 16 \
  --jellyfish-hash-size 1600M \
  --work-on-disk \
  --threads 16 \
  --db krakendb

# remove unnecessary files

# tar a file

# test database by running kraken
/kraken/kraken \
  --db krakendb \
  --fasta-input \
  --quick \
  --threads 16 \
  --output kraken-test-out.txt
