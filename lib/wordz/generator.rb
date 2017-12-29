require "json"

module Wordz
  class Generator
    include PostProcessor

    attr_reader :subjects, :output, :grammar

    ROOT_NODE = "<root>".freeze

    def initialize(grammar: {}, subjects: {})
      @output = []
      @subjects = subjects
      @grammar = grammar
    end

    def call(root_node = nil)
      root_node ||= ROOT_NODE
      post_process(generate_list(root_node))
    end

    private

    def build_instruction(str)
      Wordz::Instruction.new(str)
    end

    def generate_list(key)
      instruction_lists = grammar[key]

      if instruction_lists
        instruction_lists.sample.each(&method(:evaluate_instruction))
        output
      else
        raise UndefinedMacroError, "Grammar does not contain key #{key}."
      end
    end

    def evaluate_instruction(instruction_text)
      instruction = build_instruction(instruction_text)

      if instruction.macro?
        evaluate_macro(instruction)
      elsif instruction.method?
        evaluate_method(instruction)
      else
        evaluate_literal(instruction)
      end
    end

    def evaluate_literal(instruction)
      with_probability(instruction) do
        output << instruction.content
      end
    end

    def evaluate_macro(instruction)
      with_probability(instruction) do
        generate_list(instruction.content)
      end
    end

    def evaluate_method(instruction)
      with_probability(instruction) do
        receiver = extract_method_receiver(instruction)
        method_name = extract_method_name(instruction)
        output << receiver.send(method_name)
      end
    end

    def extract_method_receiver(method_instruction)
      receiver_name = spit_method_instruction(method_instruction).first.to_sym
      subjects[receiver_name] || raise(
        UndefinedReceiverError, "No subject specified for #{receiver_name.inspect}."
      )
    end

    def extract_method_name(method_instruction)
      spit_method_instruction(method_instruction)[1]
    end

    def spit_method_instruction(method_instruction)
      method_instruction.content.split("#").reject(&:empty?)
    end

    def with_probability(instruction)
      yield if instruction.probability >= Kernel.rand
    end

    class UndefinedReceiverError < RuntimeError; end
    class UndefinedMacroError < RuntimeError; end
  end
end
