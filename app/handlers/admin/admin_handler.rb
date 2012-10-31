class AdminHandler < AbstractHandler
  helpers do
    include AdminHelper
  end

  # Restrict access to /admin
  before '/admin/*' do
    redirect '/admin' unless signed_in? or request.path == '/admin/login'
  end

  # Dashboard (or login form)
  get '/admin/?' do
    if signed_in?
      @posts = Post.recent
      @comments = Comment.recent.group_by &:post unless Conf[:disqus]
      admin_erb :dashboard
    else
      admin_erb :login
    end
  end

  # Login form
  get '/admin/login/?' do
    admin_erb :login
  end

  # Login
  post '/admin/login/?' do
    success = if !Eridu.production? && params[:bypass]
      true
    else
      if resp = request.env[Rack::OpenID::RESPONSE]
        resp.status == :success && Conf[:author, :open_id].include?(resp.identity_url)
      else
        headers 'WWW-Authenticate' => Rack::OpenID.build_header(:identifier => params['openid_identifier'])
        throw :halt, [401, 'got openid?']
      end
    end

    if success
      session.clear
      token = MortalToken.new
      session[:salt] = token.salt
      session[:token] = token.hash
      redirect('/admin')
    else
      admin_erb(:login)
    end
  end

  # Logout
  get '/admin/logout/?' do
    session.clear
    redirect '/admin'
  end

  # Preview Textile as HTML
  post '/textile-preview' do
    RedCloth.new(params[:body].to_s).to_html
  end
end
