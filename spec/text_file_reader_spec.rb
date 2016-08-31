require_relative '../lib/text_file_reader'
require 'rspec'

describe TextFileReader do
  let(:file_path) { './spec/fixtures/test.txt' }
  let(:text_file_reader) { TextFileReader.new(file_path) }

  describe 'text' do
    subject { text_file_reader.text }
    it { is_expected.to eq('this is a test file with multiple lines. Typesetting is essentially unchanged.') }
  end
end
