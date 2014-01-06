require './config/boot'

class Eridu < AbstractHandler
  use Rack::MethodOverride

  configure :development do
    enable :logging
  end

  configure :production do
    not_found do
      erb :"errors/404"
    end

    error do
      status 500
      erb :"errors/500"
    end
  end

  before do
    params.nilify! unless request.get?
  end

  use AdminHandler
  use AdminPostsAndPagesHandler
  use AdminMediaHandler
  use AdminTrashHandler

  use PublicHandler
end

Eridu.run! if $0 == __FILE__
