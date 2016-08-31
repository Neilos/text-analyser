require_relative '../lib/directory_analyser'
require_relative '../lib/Text'
require 'rspec'

describe DirectoryAnalyser do
  let(:directory) { './spec/fixtures/*' }
  let(:directory_analyser) { DirectoryAnalyser.new(directory) }

  describe '#analyse' do
    let(:expected) {
      {
        "typesetting" => 19.136383302442574,
        "remaining" => 6.589156367788615,
        "electronic" => 6.557661854663546,
        "leap" => 6.376522597818182,
        "centuries" => 6.329414090941529,
        "survived" => 6.329414090941529,
        "industry" => 6.265217116661604,
        "printing" => 6.115437325237232,
        "essentially" => 12.404129420515735,
        "text" => 5.969394035327696,
        "dummy" => 5.703877926233863,
        "unchanged" => 11.491121188162303,
        "simply" => 5.322395652617839,
        "ipsum" => 4.434844630324079,
        "lorem" => 3.568467635072725,
        "lines" => 6.8818184127201025,
        "multiple" => 6.025265645647973,
        "file" => 4.874752588141154,
        "test" => 3.8967479717663998,
      }
    }

    it 'merges and sums the scores for the text in each file' do
      expect(directory_analyser.analyse('scored_keywords')).to eq(expected)
    end
  end
end
