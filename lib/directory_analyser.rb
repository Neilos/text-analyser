require_relative 'text'
require_relative 'text_file_reader'

class DirectoryAnalyser

  attr_reader :directory

  def initialize(directory)
    if directory.nil? || directory.empty?
      raise ArgumentError, 'directory must not be empty'
    end

    @directory = directory
  end

  def analyse(method)
    results_for(method).reduce { |memo, method_output|
      memo.merge(method_output) { |string, score_1, score_2|
        score_1 + score_2
      }
    }
  end

  private

  def results_for(method)
    texts.map { |text| text.send(method) }
  end

  def texts
    @texts ||= text_strings.map{ |text_string| Text.new(text_string) }
  end

  def text_strings
    @text_strings ||= file_paths.map { |file_path|
      TextFileReader.new(file_path).text
    }
  end

  def file_paths
    @file_paths ||= Dir[ directory ].select { |thing| File.file? thing }
  end
end
