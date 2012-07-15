# Create a fresh test database
DataMapper.auto_migrate!

# Put each step in a transaction
DatabaseCleaner.strategy = :transaction
RSpec.configure do |rspec|
  rspec.before(:each, :type => :request) { DatabaseCleaner.start }
  rspec.after(:each, :type => :request) { DatabaseCleaner.clean }
end
