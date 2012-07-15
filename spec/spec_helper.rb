ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'capybara/rspec'
require File.expand_path('../../eridu', __FILE__)
Dir[ROOT['spec', 'support', '**', '*.rb']].each { |file| require file }

Capybara.default_selector = :css
Capybara.javascript_driver = :selenium
Capybara.app = Eridu

RSpec.configure do |rspec|
  rspec.mock_with :rspec
end
