[![Gem Version](https://badge.fury.io/rb/wordz.svg)](https://badge.fury.io/rb/wordz)
[![Build](https://circleci.com/gh/hoffm/wordz.svg?style=shield&circle-token=50088f037f50e5345fe3d3054c54234a7a63fde7)](https://circleci.com/gh/hoffm/wordz)
[![Maintainability](https://api.codeclimate.com/v1/badges/63f6575f093d6762bc91/maintainability)](https://codeclimate.com/github/hoffm/wordz/maintainability)

# Wordz

A minimalist generative grammar library. For use in bots and other mischief.

# Usage

```ruby
grammar = {
  "<root>" => [
    ["#dog#name#", "says", "<bark>", "."],
  ],
  "<bark>" => [
    ["ruff"],
    ["woof"],
  ]
}

class Dog
  def name
    "Daisy"
  end
end

Wordz.generate(
  grammar: grammar,
  subjects: { dog: Dog.new },
)

# Will return one of the following, at random.
# => "Daisy says ruff."
# => "Daisy says arf." 
```
