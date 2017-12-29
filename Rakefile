require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :irb do
  desc "Open interactive REPL with our application preloaded"

  task :console do
    system("irb -r ./lib/wordz.rb")
  end
end
