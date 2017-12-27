module Wordz
  module PostProcessor
    NO_SPACE_BEFORE = %w(. , ! ?).freeze
    POST_PROCESSED_PHRASES = {
      "$INDEF_ARTICLE".freeze => :indefinite_article,
    }.freeze

    private

    def post_process(phrase_list)
      sentence_join(replace_ppps(phrase_list))
    end

    def indefinite_article(phrase_list, i)
      next_phrase = phrase_list[i + 1]
      vowel_initial?(next_phrase) ? "an" : "a"
    end

    def replace_ppps(phrase_list)
      phrase_list.each_with_index.map do |phrase, i|
        method_name = POST_PROCESSED_PHRASES[phrase]
        method_name ? send(method_name, phrase_list, i) : phrase
      end
    end

    def sentence_join(phrase_list)
      phrase_list.reduce("") do |accum_text, phrase|
        prefix = NO_SPACE_BEFORE.include?(phrase) ? "" : " "
        accum_text << (prefix + phrase)
      end.strip.squeeze(" ")
    end

    def vowel_initial?(str)
      str[0] =~ /[aeiou]/i
    end
  end
end
