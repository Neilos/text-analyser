require 'engtagger'
require 'graph-rank'

class Text
  def initialize(
      string,
      keyword_scorer = GraphRank::Keywords.new,
      grammar_analyser = EngTagger.new
    )
    @string = string
    @keyword_scorer = keyword_scorer
    @grammar_analyser = grammar_analyser
  end

  def adjectives
    grammar_analyser.get_adjectives(tagged_string)
  end

  def noun_phrases
    grammar_analyser.get_words(string)
  end

  def scored_keywords
    Hash[keyword_scorer.run(string)]
  end

  def to_s
    string
  end

  private

  def tagged_string
    @tagged_string ||= grammar_analyser.add_tags(string)
  end

  attr_reader :string, :keyword_scorer, :grammar_analyser
end
