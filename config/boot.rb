ROOT = lambda { |*paths| File.join(File.expand_path('../..', __FILE__), *paths) }
APP_ENV = ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development

# Load libraries and gems
ENV['BUNDLE_GEMFILE'] ||= ROOT['Gemfile']
require 'yaml'
require 'bundler/setup'
Bundler.require(:default, APP_ENV)

# Load everything in lib
Dir.glob(ROOT['lib', '**', '*.rb']).each { |lib| require lib }

# Set up mail
Mail.defaults do
  method = APP_ENV == :test ? :test : Conf[:mail, :method].to_sym
  delivery_method method, Conf[:mail, :settings] || {}
end if Conf[:mail]

# Set up reCAPTCHA
RCC_PUB = Conf[:recaptcha, :public_key]
RCC_PRIV = Conf[:recaptcha, :private_key]

# Initialize database connection
DataMapper::Logger.new($stdout, :debug) if APP_ENV == :development
DataMapper.setup(:default, Conf[:database])
# Load models
Dir.glob(ROOT['app', 'models', '*.rb']).sort.each { |model| require model }
DataMapper.finalize
# Raw db access, be careful!
DB = lambda { |*args| repository(:default).adapter.select(*args) }

# Load helpers and handlers
Dir.glob(ROOT['app', 'helpers', '**', '*.rb']).each { |helper| require helper }
Dir.glob(ROOT['app', 'handlers', '**', '*.rb']).sort.each { |handlers| require handlers }
