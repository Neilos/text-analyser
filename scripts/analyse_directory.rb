require 'optparse'
require 'csv'
require_relative '../lib/directory_analyser'

options = {
  number_of_results: nil,
  directory: './files_to_analyse/*'
}

OptionParser.new do |opts|
  opts.banner = "Usage: analyse_text.rb [options]"

  opts.on('-n', '--number INTEGER', 'Number of results') { |n|
    options[:number_of_results] = n.to_i
  }

  opts.on('-d', '--directory PATH', 'Directory to analyse') { |d|
    options[:directory] = d
  }

end.parse!

directory = options[:directory]
method = ARGV[0]
number_of_results = options[:number_of_results]

result = DirectoryAnalyser.new(directory).analyse(method)

if result.nil?
  puts 'Nothing to analyse (?)'
  puts
else
  result = result.sort_by { |phrase, score| -score }
  result = result.take(number_of_results) unless number_of_results.nil?

  p result.map(&:first)

  output_quantity = number_of_results ? "top#{number_of_results}" : 'all'
  timestamp = Time.now.to_i
  csv_file_path = "./csv_output/#{method}_#{output_quantity}_#{timestamp}.csv"

  CSV.open(csv_file_path, "w") do |csv|
    csv << ['TEXT', 'SCORE']
    result.each do |row|
      csv << row
    end
  end

  puts
  puts "See csv file #{csv_file_path} for results"
  puts
end
