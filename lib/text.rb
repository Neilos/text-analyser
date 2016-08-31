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

  def adjective_counts
    downcase_keys(grammar_analyser.get_adjectives(tagged_string))
  end

  def noun_phrase_counts
    downcase_keys(grammar_analyser.get_words(string))
  end

  def scored_keywords
    @scored_keywords ||= Hash[keyword_scorer.run(string)]
  end

  def scored_adjectives
    convert_to_scored(adjective_counts)
  end

  def scored_noun_phrases
    convert_to_scored(noun_phrase_counts)
  end

  def to_s
    string
  end

  private

  def downcase_keys(hash)
    Hash[hash.map { |key, value| [key.downcase, value] }]
  end

  def score_string_of(words)
    words
      .split(/\W+/)
      .reduce(0) { |sum, word|
        sum + scored_keywords.fetch(word, 0)
      }
  end

  def convert_to_scored(hash)
    hash.each_with_object({}) { |(words, count), scored|
      scored[words] = count > 0 ? score_string_of(words) : 0
    }
  end

  def tagged_string
    @tagged_string ||= grammar_analyser.add_tags(string)
  end

  attr_reader :string, :keyword_scorer, :grammar_analyser
end
