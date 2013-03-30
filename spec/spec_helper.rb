ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'capybara/rspec'
require File.expand_path('../../eridu', __FILE__)
Dir[ROOT['spec', 'support', '**', '*.rb']].each { |file| require file }

Capybara.default_selector = :css
Capybara.app = Eridu

RSpec.configure do |rspec|
  rspec.include Capybara::DSL
  rspec.mock_with :rspec
end
