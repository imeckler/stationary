#!/bin/sh

set -eu

dune build @all

if [ -d "_site" ]; then
  rm -r _site
fi

dune exec src/build_site.exe

( cd _site
  python -m SimpleHTTPServer
)
