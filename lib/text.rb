class Text
  def initialize(string)
    @string = string
  end

  def to_s
    string
  end

  private

  attr_reader :string
end
