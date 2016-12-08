#!/bin/bash

set -euo pipefail

databases=(
Zea_mays
human
bacteria
)

for database in "${databases[@]}"; do
  perl download_${database}.pl
done

# there's a step here I need to work out where the human database gets stuck
# someplace random and weird

exit

/kraken/kraken-build \
  --download-taxonomy \
  --db krakendb

for database in "${databases[@]}"; do
  for fna in ${database}/*.tax.fna; do
    /kraken/kraken-build \
      --add-to-library ${fna} \
      --db krakendb
  done
done

./kraken/kraken-build \
  --max-db-size 32 \
  --jellyfish-hash-size 3200M \
  --work-on-disk \
  --threads 32 \
  --db krakendb
