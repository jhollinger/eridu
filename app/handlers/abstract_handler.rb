# Base class for all Eridu handlers
class AbstractHandler < Sinatra::Base
  # Configure Handler
  register Sinatra::Flash
  set :views, ROOT['app', 'views']
  set :public_folder, ROOT['public']

  # Include global helpers
  helpers do
    include Helpers
    include HTMLHelpers
    include Rack::Recaptcha::Helpers if Conf[:recaptcha]
    alias_method :h, :escape_html
  end

  before do
    params.nilify! unless request.get?
  end

  before '/admin/*' do
    redirect '/admin' unless signed_in? or request.path == '/admin/login'
  end

  configure :production, :development do
    enable :logging
  end

  configure :production do
    not_found do
      erb :"errors/404"
    end

    error do
      mail Conf[:author, :email], 'Eridu Exception', :exception if Conf[:mail, :errors]
      status 500
      erb :"errors/500"
    end
  end
end
