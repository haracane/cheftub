# coding: utf-8
if RUBY_VERSION <= '1.8.7'
else
  require "simplecov"
  require "simplecov-rcov"
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require "rspec"
require "cheftub"
require "tempfile"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

module Cheftub
  REDIRECT = {}
end

Cheftub.logger = Logger.new(STDERR)
if File.exist?('/tmp/cheftub.debug') then
  Cheftub.logger.level = Logger::DEBUG
  Cheftub::REDIRECT[:stdout] = nil
  Cheftub::REDIRECT[:stderr] = nil
else
  Cheftub.logger.level = Logger::ERROR
  Cheftub::REDIRECT[:stdout] = "> /dev/null"
  Cheftub::REDIRECT[:stderr] = "2> /dev/null"
end
