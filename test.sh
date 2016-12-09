#!/bin/bash

set -euo pipefail

image="registry.pivotbio.me/kraken-builder"

docker build --tag ${image} .

docker run -ti ${image}
