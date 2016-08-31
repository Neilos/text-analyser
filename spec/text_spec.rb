require_relative '../lib/text'
require 'rspec'

describe Text do
  let(:keyword_scorer) { double('keyword scorer') }
  let(:grammar_analyser) { double('grammar analyser') }
  let(:text) { Text.new(string, keyword_scorer, grammar_analyser) }

  describe '#to_s' do
    let(:string) { 'here is some text to analyse' }
    subject { text.to_s }
    it { is_expected.to eq(string) }
  end

  describe '#scored_keywords' do
    let(:string) { 'here is some text to analyse' }

    before do
      allow(keyword_scorer).to receive(:run)
        .and_return([ ["text", 3.7], ["analyse", 4.5] ])
    end

    subject { text.scored_keywords }
    it { is_expected.to eq({"text" => 3.7, "analyse" => 4.5}) }
  end

  describe 'adjectives' do
    let(:string) { "Alice chased the big fat cat." }
    let(:tagged_string) { "<nnp>Alice</nnp> <vbd>chased</vbd> <det>the</det> <jj>big</jj> <jj>fat</jj><nn>cat</nn> <pp>.</pp>" }
    let(:expected_adjectives) { { "big"=>1, "fat"=>1 } }

    before do
      allow(grammar_analyser).to receive(:add_tags)
        .with(string)
        .and_return(tagged_string)

      allow(grammar_analyser).to receive(:get_adjectives)
        .with(tagged_string)
        .and_return(expected_adjectives)
    end

    subject { text.adjectives }
    it { is_expected.to eq(expected_adjectives) }
  end
end
