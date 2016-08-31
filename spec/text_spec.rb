require_relative '../lib/text'
require 'rspec'

describe Text do
  let(:string) { 'some text here' }
  let(:text) { Text.new(string) }

  describe 'to_s' do
    subject { text.to_s }
    it { is_expected.to eq(string) }
  end
end
