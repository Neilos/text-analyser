require 'optparse'
require 'pismo'
require 'sanitize'
require_relative '../lib/text_file'

options = {
  file_containing_urls: './urls_to_scrape.txt',
  output_directory: './files_to_analyse/',
}

OptionParser.new do |opts|
  opts.banner = "Usage: scrape_text.rb [options]"

  opts.on('-o', '--directory PATH', 'Directory to output files') { |o|
    options[:output_directory] = o
  }

  opts.on('-u', '--urls FILE_PATH', 'File containing urls to process') { |u|
    options[:file_containing_urls] = u
  }
end.parse!

output_directory = options[:output_directory]

urls = File.readlines(options[:file_containing_urls]).reject { |url|
  url.start_with?('<!--') || url.strip.length == 0
}.map(&:chomp)

urls.each do |url|
  puts "scraping: #{url}"

  begin
    document = Pismo::Document.new(url)
    text = Sanitize
      .clean(document.html, remove_contents: ['script', 'style', 'img', 'nav', 'header', 'title', 'footer', 'a'])
      .gsub(/(\n)/, '. ')
      .gsub(/\s\s+/, ' ')
      .gsub(/(\.\s)+/, '. ')

    if text.strip.length > 1 && text.split(/\s/).count > 2
      filename = url.gsub(/(\/|\.|:)/, '-')
      TextFile.new(text, "#{output_directory}#{filename}.txt").save
    else
      print ' - NO TEXT TO SAVE'
    end
  rescue RuntimeError => error
    puts " - error: #{error}"
  end
end

puts "Done! see directory: #{output_directory}"

