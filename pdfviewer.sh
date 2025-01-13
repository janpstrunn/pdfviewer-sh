#!/bin/env bash

function help() {
  cat << EOF
CLI PDF Viewer
Usage: $0 [option] path/to/pdf
Available options:
  -h, --help                     - Displays this message and exits
  -p, --pager                    - Use alternative pager
  -w, --wrap                     - Wraps text, if text format is used
EOF
  exit 0
}

cachedir="$HOME/.cache/pdfviewer"
html=("lynx" "w3m")
pager="${PAGER:-less}"
wrap=false
pdfile=""
parsedfile=""

if [ ! -d "$cachedir" ]; then
  mkdir -p "$cachedir"
  echo "Cache directory created at $cachedir!"
  echo "This directory contains all parsed PDF files for future usage!"
fi

while [[ "$1" != "" ]]; do
  case "$1" in
    -w | --wrap)
      wrap=true
      shift
      ;;
    -h | --help)
      help
      exit 0
      ;;
    -p | --pager)
      shift
      pager="$1"
      shift
      pdfile="$1"
      parsedfile=$(basename "$pdfile" .pdf)
      ;;
    *)
      pdfile="$1"
      parsedfile=$(basename "$pdfile" .pdf)
      ;;
  esac
  shift
done

if [[ -z "$pdfile" ]]; then
  echo "Error: No PDF file specified."
  help
  exit 1
fi

if [ "$wrap" = true ]; then
  if [ -f "$cachedir/$parsedfile.txt" ]; then
    cat "$cachedir/$parsedfile.txt" | fmt -w $(tput cols) | "$pager"
  else
    mutool draw -F text "$pdfile" > "$cachedir/$parsedfile.txt"
    cat "$cachedir/$parsedfile.txt" | fmt -w $(tput cols) | "$pager"
  fi
else
  if [ -f "$cachedir/$parsedfile.txt" ]; then
    "$pager" "$cachedir/$parsedfile.txt"
  else
    mutool draw -F text "$pdfile" > "$cachedir/$parsedfile.txt"
    "$pager" "$cachedir/$parsedfile.txt"
  fi
fi
