class TextFile
  attr_reader :text, :file_path, :file_writer

  def initialize(text, file_path, file_writer = File)
    @text = text
    @file_path = file_path
    @file_writer = file_writer
  end

  def save
    file_writer.open(file_path, 'w') do |file|
      file.write(text)
    end
  end
end
