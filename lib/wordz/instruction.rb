module Wordz
  class Instruction
    attr_reader :probability, :content

    PROBABILITY_PATTERN = /(\|0\.[0-9]+)/
    MACRO_PATTERN = /^<.+>$/
    METHOD_PATTERN = /^\#.+\#.+\#$/

    def initialize(str)
      @content = extract_content(str)
      @probability = extract_probability(str)
    end

    def macro?
      content.match?(MACRO_PATTERN)
    end

    def method?
      content.match?(METHOD_PATTERN)
    end

    private

    def extract_probability(str)
      if prob_match_data(str)
        prob_match_data(str).captures.last.delete("|")
      else
        1
      end.to_f
    end

    def extract_content(str)
      prob_match_data(str) ? prob_match_data(str).pre_match : str
    end

    def prob_match_data(str)
      PROBABILITY_PATTERN.match(str)
    end
  end
end
