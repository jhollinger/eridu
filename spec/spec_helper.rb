ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'capybara/rspec'
require File.expand_path('../../eridu', __FILE__)

DataMapper.auto_migrate!
DatabaseCleaner.strategy = :transaction

Capybara.default_selector = :css
Capybara.javascript_driver = :selenium
Capybara.app = Eridu

RSpec.configure do |rspec|
  rspec.mock_with :rspec
  rspec.before(:each, :type => :request) { DatabaseCleaner.start }
  rspec.after(:each, :type => :request) { DatabaseCleaner.clean }
end
