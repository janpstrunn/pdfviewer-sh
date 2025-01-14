#!/bin/env bash

function help() {
  cat << EOF
CLI PDF Viewer
Usage: $0 [option] path/to/pdf
Available options:
  -e, --expand [-p]                   - Expand text, if text format is used
  -f, --fzf                           - Fuzzy finder parsed files
  -h, --help                          - Displays this message and exits
  -hl, --html                         - Create HTML file instead of text
  -p, --pager [arg]                   - Use alternative pager
  -v, --voice [profile]               - Use RHVoice as TTS
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

function html() {
  if [ ! -f "$cachedir/$parsedfile.html" ]; then
    mutool draw -F html "$pdfile" > "$cachedir/$parsedfile.html"
    echo "$parsedfile.html created at $cachedir!"
  else
    echo "$parsedfile.html already exists!"
    echo "Use $0 -f to view it!"
  fi
}

function fzf_root() {
  parsedfile=$(find "$cachedir" -type f | fzf)
  if [[ $parsedfile == *.html ]]; then
    pager="lynx"
  fi
}

function voice() {
  cat "$parsedfile" | RHVoice-test -p "$profile" -q 200%
  exit
}

while [[ "$1" != "" ]]; do
  case "$1" in
    -v | --voice)
      profile="$2"
      fzf_root
      voice
      exit
      ;;
    -f | --fzf)
      fzf_root
      "$pager" "$parsedfile"
      exit
      ;;
    -w | --wrap)
      wrap=true
      shift
      ;;
    -h | --help)
      help
      exit 0
      ;;
    -hl | --html)
      shift
      pdfile="$1"
      parsedfile=$(basename "$pdfile" .pdf)
      html
      exit
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

html_view=("lynx" "w3m")

for is_html in "${html_view[@]}"; do
  if [ "$pager" = "$is_html" ]; then
    "$pager" "$cachedir/$parsedfile.html"
    exit
  fi
done

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
