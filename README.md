# Text Analyser

## Setup

Requires the installation of the headless browser Phantomjs

`brew install phantomjs`

Install the project's ruby dependencies with 

`bundle`

## Tests

Tests are written in rspec.
To run the tests, in your terminal, from the root of this directory, execute the following command:

`rspec spec/`

## Usage

(All instructions assume commands are run from the root of this directory)

### 1. To crawl a list of domains and output a list of urls from those domains...

  a) Add domains to the file 'domains_to_crawl.txt': one per line. (You can also comment out domains with html comment tags: `<!-- -->`)
  
  b) Run the command `ruby ./scripts/crawl_domains.rb`

### 2. To scrape a list of urls and output all text to a directory...
  
  a) Check the file 'urls_to_scrape.txt' and add or remove any urls as appropriate (you can also comment out urls with html comment tags: `<!-- -->`)

  b) Move any existing files in the directory 'files_to_analyse/' to avoid overwriting.

  c) Run the command `ruby ./scripts/scrape_text.rb`

### 3. To analyse a directory of text files...

  a) Clear/move any files in the directory 'files_to_analyse/' that you **don't** want to include in the analysis.

  b) Run the command `ruby ./scripts/analyse_directory.rb analysis_method`, where the `analysis_method` can be any of the following:

    adjective_counts

    noun_phrase_counts

    scored_keywords

    scored_adjectives

    scored_noun_phrases


