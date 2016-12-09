set -euo pipefail

databases=(
Zea_mays
human
bacteria
archaea
)

for database in "${databases[@]}"; do
  echo "----> downloading ${database}"
  perl download_${database}.pl
done

mkdir human
mv *.tax.fna human/

# there's a step here I need to work out where the human database gets stuck
# someplace random and weird

/kraken/kraken-build \
  --download-taxonomy \
  --db krakendb

for database in "${databases[@]}"; do
  for fna in ${database}/*.tax.fna; do
    /kraken/kraken-build \
      --add-to-library ${fna} \
      --db krakendb
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
