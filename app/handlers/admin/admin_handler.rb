class AdminHandler < AbstractHandler
  helpers do
    include AdminHelper
  end

  # Dashboard (or login form)
  get '/admin/?' do
    if signed_in?
      @posts = Post.recent
      @comments = Comment.recent.group_by &:post
      admin_erb :dashboard
    else
      admin_erb :login
    end
  end

  # Site stats
  get '/admin/stats/?' do
    @posts, @comments, @tags = Post.count, Comment.count, Tag.count
    admin_erb :stats
  end

  # Login form
  get '/admin/login/?' do
    admin_erb :login
  end

  # Login
  post '/admin/login/?' do
    success = if Eridu.development? and params[:bypass]
      true
    else
      if resp = request.env[Rack::OpenID::RESPONSE]
        if resp.status == :success
          session.clear
          token = AuthToken.new
          session[:salt] = token.salt
          session[:token] = token.to_s
          true
        else
          false
        end
      else
        headers 'WWW-Authenticate' => Rack::OpenID.build_header(:identifier => params['openid_identifier'])
        throw :halt, [401, 'got openid?']
      end
    end
    success ? redirect('/admin') : admin_erb(:login)
  end

  # Logout
  get '/admin/logout/?' do
    session.clear
    redirect '/admin'
  end
end
