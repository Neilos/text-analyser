require_relative '../lib/directory_analyser'
require 'rspec'

describe DirectoryAnalyser do
  let(:directory) { './spec/fixtures/*' }
  let(:directory_analyser) { DirectoryAnalyser.new(directory) }

  describe '#file_paths' do
    let(:expected_file_paths) {
      [ './spec/fixtures/test.txt',
        './spec/fixtures/another_test.txt' ]
    }

    subject { directory_analyser.file_paths }
    it { is_expected.to match_array(expected_file_paths) }
  end

  describe '#text_string' do
    let(:expected_text_string) { 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.  It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. this is a test file with multiple lines. ' }
    subject { directory_analyser.text_string }
    it { is_expected.to eq(expected_text_string) }
  end
end
