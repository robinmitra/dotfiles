#!/bin/bash

PATH=/usr/local/bin/:$PATH
QUERY=$1
[[ ${QUERY} ]] || exit 1
DIR="/tmp/alfred-readme/${QUERY}"
README="${DIR}/README.md"
mkdir -p "${DIR}" && \
  npm view "${QUERY}" readme > "${README}" && \
  open "${README}"