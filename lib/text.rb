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
    downcase_keys(grammar_analyser.get_adjectives(tagged_string))
  end

  def noun_phrases
    downcase_keys(grammar_analyser.get_words(string))
  end

  def scored_keywords
    @scored_keywords ||= Hash[keyword_scorer.run(string)]
  end

  def scored_noun_phrases
    noun_phrases.each_with_object({}) { |(phrase, count), scored|
      scored[phrase] = count > 0 ? score(phrase) : 0
    }
  end

  def to_s
    string
  end

  private

  def downcase_keys(hash)
    Hash[hash.map { |key, value| [key.downcase, value] }]
  end

  def score(string)
    string
      .split(/\W+/)
      .reduce(0) { |sum, word| sum + scored_keywords.fetch(word, 0) }
  end

  def tagged_string
    @tagged_string ||= grammar_analyser.add_tags(string)
  end

  attr_reader :string, :keyword_scorer, :grammar_analyser
end
