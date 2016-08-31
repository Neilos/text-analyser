require_relative 'text'
require_relative 'text_file_reader'

class DirectoryAnalyser

  attr_reader :directory

  def initialize(directory)
    raise ArgumentError, 'directory must not be empty' if directory.empty?

    @directory = directory
  end

  def text
    @text ||= Text.new(text_string)
  end

  def text_string
    @text_string ||= file_paths.reduce('') do |string, file_path|
      string << TextFileReader.new(file_path).text << ' '
    end
  end

  def file_paths
    @file_paths ||= Dir[ directory ].select { |thing| File.file? thing }
  end
end
