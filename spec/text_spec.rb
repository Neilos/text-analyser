require_relative '../lib/text'
require 'rspec'

describe Text do
  let(:string) { 'here is some text to analyse' }
  let(:keyword_scorer) { double('keyword scorer') }
  let(:text) { Text.new(string, keyword_scorer) }

  describe '#to_s' do
    subject { text.to_s }
    it { is_expected.to eq(string) }
  end

  describe '#scored_keywords' do
    before do
      allow(keyword_scorer).to receive(:run)
        .and_return([ ["text", 3.7], ["analyse", 4.5] ])
    end

    subject { text.scored_keywords }
    it { is_expected.to eq({"text" => 3.7, "analyse" => 4.5}) }
  end
end
