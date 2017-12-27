require "wordz/version"

WORDZ_APP_PATH = File.expand_path("../", __FILE__) + "/wordz"

module Wordz
  autoload(:PostProcessor, "#{WORDZ_APP_PATH}/post_processor.rb")
end

Dir["#{WORDZ_APP_PATH}/**/*.rb"].each { |file| require file }
