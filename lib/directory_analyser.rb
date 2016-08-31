class DirectoryAnalyser

  attr_reader :directory

  def initialize(directory)
    raise ArgumentError, 'directory must not be empty' if directory.empty?

    @directory = directory
  end

  def file_paths
    Dir[ directory ].select { |thing| File.file? thing }
  end
end
