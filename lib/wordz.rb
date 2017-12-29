require "wordz/version"

WORDZ_APP_PATH = File.expand_path("../", __FILE__) + "/wordz"

module Wordz
  autoload(:PostProcessor, "#{WORDZ_APP_PATH}/post_processor.rb")
  autoload(:Client, "#{WORDZ_APP_PATH}/client.rb")

  extend Wordz::Client
end

Dir["#{WORDZ_APP_PATH}/**/*.rb"].each { |file| require file }
