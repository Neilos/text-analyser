require 'optparse'
require 'anemone'
require_relative '../lib/text_file'
require 'byebug'

options = {
  file_containing_urls: './domains_to_crawl.txt',
  output_file: './urls_to_scrape.txt',
}

OptionParser.new do |opts|
  opts.banner = "Usage: scrape_text.rb [options]"

  opts.on('-u', '--urls FILE_PATH', 'File containing urls to process') { |u|
    options[:file_containing_urls] = u
  }

  opts.on('-o', '--output FILE_PATH', 'File to output list of urls') { |o|
    options[:output_file] = o
  }
end.parse!

domain_urls = File.readlines(options[:file_containing_urls]).map do |line|
  line.chomp
end

urls_found = []

begin
  domain_urls.reject { |domain_url|
    domain_url.start_with? '<!--' || domain_url.strip.length == 0
  }.each do |domain_url|
    urls_found << domain_url
    puts "found: #{domain_url}"
    Anemone.crawl(domain_url) do |anemone|
      anemone.on_every_page do |page|

        page_is_html = page.content_type.match(/html/)
        page_url = page.url.to_s
        page_already_visited = urls_found.include?(page_url)
        page_is_cgi_cdn = page_url.match(/cdn-cgi/)

        if page_is_html && !page_already_visited && !page_is_cgi_cdn
          puts "found: #{page_url}"
          urls_found << page_url
        end

        page.discard_doc! # don't need anemone to store the document
      end
    end
  end
rescue StandardError => error
  puts
  puts error
ensure
  File.open(options[:output_file], 'w') do |file|
    file.write(urls_found.uniq.sort.join("\n"))
  end

  puts
  puts 'Done! See urls_to_process.txt for list of urls found'
end

