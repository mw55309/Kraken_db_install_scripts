#!/bin/bash

set -euo pipefail

docker build --tag kraken-builder .

docker run -ti kraken-builder
