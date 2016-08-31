require_relative '../lib/text_file'
require 'rspec'

describe TextFile do
  let(:text_file) { TextFile.new(text, file_path, file_writer) }
  let(:text) { 'some text' }
  let(:file_path) { 'some/path/to/file.txt' }

  describe 'save' do
    let(:file_writer) { double('file_writer') }
    let(:buffer) { StringIO.new }

    it 'saves text to a file with the given name' do
      allow(file_writer).to receive(:open)
        .with(file_path, 'w')
        .and_yield(buffer)

      text_file.save

      expect(buffer.string).to eq(text)
    end
  end
end
