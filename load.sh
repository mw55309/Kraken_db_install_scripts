#!/bin/bash

set -euo pipefail

database="gi_taxids"

echo "----> creating database"
dropdb "${database}" || true
createdb "${database}"

psql \
  --dbname "${database}" \
  --command "CREATE TABLE gi_taxids (GI int, TAXID int);" 

echo "----> loading data"
pv gi_taxid_nucl.dmp.gz \
  | gzcat \
  | tr '\t' ',' \
  | psql \
    --dbname "${database}" \
    --command "\copy gi_taxids(GI, TAXID) FROM '/dev/stdin' DELIMITER ',' CSV" || true

echo "----> indexing"
psql \
  --dbname "${database}" \
  --command "CREATE INDEX CONCURRENTLY gi_index ON gi_taxids(GI);"

psql \
  --dbname "${database}" \
  --command "CREATE INDEX CONCURRENTLY taxid_index ON gi_taxids(TAXID);"

