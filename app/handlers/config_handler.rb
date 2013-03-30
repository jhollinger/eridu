# Config for the main app (doesn't belong in AbstractHandler, because it only needs to be defined once)
class ConfigHandler < AbstractHandler
  use Rack::MethodOverride
  use Rack::Session::Cookie, :key => 'eridu.session', :httponly => true, :path => '/admin', :secret => Conf[:secret_token]
  use Rack::OpenID
  use Rack::Recaptcha, :public_key => Conf[:recaptcha, :public_key], :private_key => Conf[:recaptcha, :private_key] if Conf[:recaptcha]

  configure :development do
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

  before do
    params.nilify! unless request.get?
  end
end
