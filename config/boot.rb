ROOT = ->(*paths) { File.join(File.expand_path('../..', __FILE__), *paths) }
APP_ENV = ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development

# Load libraries and gems
ENV['BUNDLE_GEMFILE'] ||= ROOT['Gemfile']
require 'base64'
require 'psych'
require 'bundler/setup'
Bundler.require(:default, APP_ENV)

# Load config
DB_CONFIG = Psych.load_file(ROOT['config', 'database.yml'])[APP_ENV]
Conf = Psych.load_file(ROOT['config', 'eridu.yml'])

# Initialize database connection
DataMapper::Logger.new($stdout, :debug) if APP_ENV == :development
DataMapper.setup(:default, DB_CONFIG)
# Load everything in lib
Dir.glob(ROOT['lib', '**', '*.rb']).each { |lib| require lib }
# Load models
Dir.glob(ROOT['app', 'models', '**', '*.rb']).each { |model| require model }
DataMapper.finalize

# Load helpers and handlers
Dir.glob(ROOT['app', 'helpers', '**', '*.rb']).each { |helper| require helper }
Dir.glob(ROOT['app', 'handlers', '**', '*.rb']).sort.each { |handlers| require handlers }
