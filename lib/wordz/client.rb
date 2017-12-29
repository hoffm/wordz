module Wordz
  module Client
    def generate(grammar: {}, subjects: {}, root: nil)
      Generator.new(
        grammar: grammar,
        subjects: subjects,
      ).call(root)
    end
  end
end
