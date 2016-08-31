class TextFileReader
  attr_reader :text

  def initialize(file_path)
    @text = ''
    File.foreach(file_path) do |line|
      @text << line.chomp << ' '
    end
    @text.rstrip!
  end
end
