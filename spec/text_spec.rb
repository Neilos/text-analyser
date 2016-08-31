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

  describe 'adjective_counts' do
    let(:string) { "Alice chased the Big fat cat." }
    let(:tagged_string) { "<nnp>Alice</nnp> <vbd>chased</vbd> <det>the</det> <jj>Big</jj> <jj>fat</jj><nn>cat</nn> <pp>.</pp>" }
    let(:adjective_counts) { { "Big"=>1, "fat"=>1 } }
    let(:expected_adjective_counts) { { "big"=>1, "fat"=>1 } }

    before do
      allow(grammar_analyser).to receive(:add_tags)
        .with(string)
        .and_return(tagged_string)

      allow(grammar_analyser).to receive(:get_adjectives)
        .with(tagged_string)
        .and_return(adjective_counts)
    end

    subject { text.adjective_counts }
    it { is_expected.to eq(expected_adjective_counts) }
  end

  describe 'noun_phrases_counts' do
    let(:string) { "Alice chased the big fat cat." }
    let(:noun_phrase_counts) {
      { "Alice"=>1, "cat"=>1, "fat cat"=>1, "big fat cat"=>1 }
    }
    let(:expected_noun_phrase_counts) {
      { "alice"=>1, "cat"=>1, "fat cat"=>1, "big fat cat"=>1 }
    }

    before do
      allow(grammar_analyser).to receive(:get_words).with(string)
        .and_return(noun_phrase_counts)
    end

    subject { text.noun_phrase_counts }
    it { is_expected.to eq(expected_noun_phrase_counts) }
  end

  describe '#scored_noun_phrases' do
    let(:string) { "Alice chased the big fat cat." }
    let(:noun_phrases) {
      { "Alice"=>1, "cat"=>1, "fat cat"=>1, "big fat cat"=>1 }
    }

    let(:scored_keywords) {
      {
        "big"    => 6.1,
        "fat"    => 6.0,
        "cat"    => 5.7,
        "chased" => 5.4,
        "alice"  => 4.0
      }
    }

    let(:expected) {
      { "alice"=>4.0, "cat"=>5.7, "fat cat"=>11.7, "big fat cat"=>17.8 }
    }

    before do
      allow(keyword_scorer).to receive(:run).and_return(scored_keywords)
      allow(grammar_analyser).to receive(:get_words).with(string)
        .and_return(noun_phrases)
    end

    subject { text.scored_noun_phrases }
    it { is_expected.to eq(expected) }
  end

  describe '#scored_adjectives' do
    let(:string) { "Alice chased the Big fat cat." }
    let(:tagged_string) { "<nnp>Alice</nnp> <vbd>chased</vbd> <det>the</det> <jj>Big</jj> <jj>fat</jj><nn>cat</nn> <pp>.</pp>" }
    let(:adjectives) { { "Big"=>1, "fat"=>1 } }

    let(:scored_keywords) {
      {
        "big"    => 6.1,
        "fat"    => 6.0,
        "cat"    => 5.7,
        "chased" => 5.4,
        "alice"  => 4.0
      }
    }

    let(:expected_adjectives) { { "big"=>1, "fat"=>1 } }

    before do
      allow(keyword_scorer).to receive(:run).and_return(scored_keywords)

      allow(grammar_analyser).to receive(:add_tags)
        .with(string)
        .and_return(tagged_string)

      allow(grammar_analyser).to receive(:get_adjectives)
        .with(tagged_string)
        .and_return(adjectives)
    end

    let(:expected) { { "big"=>6.1, "fat"=>6.0 } }

    subject { text.scored_adjectives }
    it { is_expected.to eq(expected) }
  end
end
