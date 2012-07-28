# Base class for all Eridu handlers
class AbstractHandler < Sinatra::Base
  # Configure Handler
  set :views, ROOT['app', 'views']
  set :public_folder, ROOT['public']

  # Include global helpers
  helpers do
    include Helpers
    include HTMLHelpers
    include Rack::Recaptcha::Helpers if Conf[:recaptcha]
    alias_method :h, :escape_html
  end

  configure :development do
    register Sinatra::Reloader
  end

  before do
    params.nilify! unless request.get?
  end
end
