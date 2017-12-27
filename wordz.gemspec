lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wordz/version"

Gem::Specification.new do |spec|
  spec.name          = "wordz"
  spec.version       = Wordz::VERSION
  spec.authors       = ["Michael Hoffman"]
  spec.email         = ["michael.s.hoffman@gmail.com"]

  spec.summary       = "A minimalist generative grammar library."
  spec.homepage      = "https://github.com/hoffm/wordz"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.3"
end
