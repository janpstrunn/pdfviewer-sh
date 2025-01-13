# PDF Viewer

`pdfviewer.sh` is a simple shell script to simply the process to read PDF in the Terminal.

It uses mutool under the hood to convert PDF files to text or HTML files, that can be read by any viewer of choice.

## Requirements

- mutool
- fzf (for searching the cache folder)
- lynx or w3m (for viewing HTML files)
- Any viewer of choice

## Features

- Convert PDF files to text or HTML files and save to cache folder
- Search cache folder using fzf
- Expand lines, if they don't fit the whole screen

## Usage

The first time you use `pdfviewer.sh` the cache folder will be created at `$HOME/.cache/pdfviewer` by default, where all processed files will live, allowing easier access skipping the convert process.

```
CLI PDF Viewer
Usage: $0 [option] path/to/pdf
Available options:
  -e, --expand                   - Expand text, if text format is used
  -f, --fzf                      - Fuzzy finder parsed files
  -h, --help                     - Displays this message and exits
  -hl, --html                    - Create HTML file instead of text
  -p, --pager                    - Use alternative pager
```

**Examples:**

1. `pdfviewer.sh -w -p bat pdfile.pdf` To expand lines and use bat as the viewer
2. `pdfviewer.sh -f` To use fzf to search the cache folder and view files
3. `pdfviewer.sh -hl pdfile.pdf` To create a HTML file

**Important:**

- `-w` option requires `-p` option to be used

## Installation

Make sure to add the script to your `$PATH` for convenience.

```
git clone https://github.com/janpstrunn/pdfviewer
cd eureka-sh
chmod +x pdfviewer.sh
```

Tip: Set an alias for `pdfviewer`

## Notes

This script has been only tested in a Linux Machine.
