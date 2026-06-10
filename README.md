# Markdown Processor CLI Tool
## Badges
[![Language](https://img.shields.io/badge/Language-Haskell-blue)](https://www.haskell.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](https://opensource.org/licenses/MIT)

## What it does
The Markdown Processor CLI Tool is a command-line application designed to simplify the workflow of developers and writers by providing an efficient way to process and convert Markdown files. It supports various features such as Markdown to HTML conversion, Markdown to PDF conversion, text formatting, and table of contents generation. This tool aims to reduce the time and effort required to manage Markdown files.

## Features
* Markdown to HTML conversion
* Markdown to PDF conversion
* Text formatting
* Table of contents generation
* Error handling

## Requirements
* Haskell 8.10.7
* Scotty framework
* cabal (for installation and running the application)

## Installation
To install the Markdown Processor CLI Tool, follow these steps:
1. Install the Haskell Platform from the official website if you haven't already.
2. Open a terminal and run the command: `cabal update`
3. Install the required dependencies by running: `cabal install scotty`
4. Clone the repository and navigate to the project directory.
5. Run the command: `cabal install`

## Usage
To use the Markdown Processor CLI Tool, navigate to the project directory and run the following commands:
* To convert a Markdown file to HTML: `cabal run -- input.md output.html`
* To convert a Markdown file to PDF: `cabal run --pdf input.md output.pdf`
* To generate a table of contents: `cabal run --toc input.md output.html`
Expected output:
```
Input file: input.md
Output file: output.html
Conversion successful!
```

## Environment Variables
| Variable Name | Description |
| --- | --- |
| INPUT_FILE | The path to the input Markdown file |
| OUTPUT_FILE | The path to the output file |
| FORMAT | The output format (html or pdf) |
| TABLE_OF_CONTENTS | A flag to generate a table of contents (true or false) |

## Project Structure
```
markdown-processor/
├── app/
│   ├── Main.hs
│   ├── MarkdownProcessor.hs
│   └── Util.hs
├── config/
│   └── default.cfg
├── src/
│   ├── Markdown.hs
│   ├── Html.hs
│   └── Pdf.hs
├── test/
│   ├── Spec.hs
│   └── TestMarkdown.hs
├── .cabal
├── LICENSE
└── README.md
```

## Contributing
To contribute to the Markdown Processor CLI Tool, follow these steps:
1. Fork the repository on GitHub.
2. Clone the repository to your local machine.
3. Create a new branch for your feature or bug fix.
4. Make your changes and commit them with a descriptive message.
5. Push your changes to your forked repository.
6. Create a pull request to the main repository.

## License
The Markdown Processor CLI Tool is licensed under the MIT License. You can find a copy of the license in the LICENSE file in the root of the repository.