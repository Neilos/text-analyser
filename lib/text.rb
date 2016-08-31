require 'graph-rank'

class Text
  def initialize(string, keyword_scorer = GraphRank::Keywords.new)
    @string = string
    @keyword_scorer = keyword_scorer
  end


  def scored_keywords
    Hash[keyword_scorer.run(string)]
  end

  def to_s
    string
  end

  private

  attr_reader :string, :keyword_scorer
end
