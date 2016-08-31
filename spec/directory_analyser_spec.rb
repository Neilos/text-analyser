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
end
